import os
import re
import yaml
from flask import Flask, render_template, request, jsonify, send_file
from jinja2 import Template
import subprocess

app = Flask(__name__, static_url_path='/static', static_folder='static')

WORKING_DIR = os.getcwd()
CONTENT_DIR = os.path.join(WORKING_DIR, "content")
GEN_DIR = os.path.join(WORKING_DIR, "generated")
WEB_DIR = os.path.join(WORKING_DIR, "templates")
DEFAULT_YAML = "default.yaml"
DEFAULT_TEMPLATE = "letter.svg.j2"

# Helpers for file operations
def get_files_by_extension(extension):
    """Returns a list of files in the working directory with the given extension."""
    return [f for f in os.listdir(CONTENT_DIR) if f.endswith(extension)]

def load_file_content(file_name):
    """Loads the content of a file."""
    file_path = os.path.join(CONTENT_DIR, file_name)
    if os.path.exists(file_path):
        with open(file_path, "r") as f:
            return f.read()
    return ""

def save_file_content(file_name, content):
    """Saves content to a file."""
    file_path = os.path.join(CONTENT_DIR, file_name)
    with open(file_path, "w") as f:
        f.write(content)

def render_svg_from_template(yaml_content, template_content):
    """Combines YAML and template to render SVG."""
    try:
        context = yaml.safe_load(yaml_content)  # Parse YAML into a Python dictionary
        template = Template(template_content)  # Load the Jinja2 template
        return template.render(context)        # Render the SVG with the context
    except Exception as e:
        raise ValueError(f"Error rendering SVG: {e}")

@app.route("/")
def index():
    """Render the main page."""
    yaml_files = get_files_by_extension(".yaml")
    template_files = get_files_by_extension(".svg.j2")
    return render_template(
        "index.html",
        yaml_files=yaml_files,
        template_files=template_files,
        default_yaml=DEFAULT_YAML,
        default_template=DEFAULT_TEMPLATE,
        default_yaml_content=load_file_content(DEFAULT_YAML),
        default_template_content=load_file_content(DEFAULT_TEMPLATE),
    )

@app.route("/file-content", methods=["GET"])
def file_content():
    """Returns the content of a specified file."""
    file_name = request.args.get("file")
    content = load_file_content(file_name)
    return jsonify({"content": content})

@app.route("/render", methods=["POST"])
def render_png():
    """Handles the render logic and saves files."""
    data = request.json
    yaml_name = data.get("yaml_name")
    yaml_content = data.get("yaml_content")
    template_name = data.get("template_name")
    template_content = data.get("template_content")

    # Validate file names
    if not re.match(r"^[a-zA-Z0-9_-]+$", yaml_name):
        return jsonify({"error": "Invalid YAML file name."}), 400
    if not re.match(r"^[a-zA-Z0-9_-]+$", template_name):
        return jsonify({"error": "Invalid template file name."}), 400

    # Save files
    yaml_file = f"{yaml_name}.yaml"
    template_file = f"{template_name}.svg.j2"
    save_file_content(yaml_file, yaml_content)
    save_file_content(template_file, template_content)

    # Combine YAML and template to render SVG
    try:
        rendered_svg = render_svg_from_template(yaml_content, template_content)
        svg_output = os.path.join(GEN_DIR, "output.svg")
        with open(svg_output, "w") as f:
            f.write(rendered_svg)
    except ValueError as e:
        return jsonify({"error": str(e)}), 500

    # Convert SVG to PNG using Inkscape
    try:
        png_output = os.path.join(GEN_DIR, "output.png")
        subprocess.run(["inkscape", svg_output, "--export-dpi=300", "--export-filename", png_output], check=True)

        # Refresh file lists
        yaml_files = get_files_by_extension(".yaml")
        template_files = get_files_by_extension(".svg.j2")

        return jsonify({
            "message": "Render successful.",
            "yaml_files": yaml_files,
            "template_files": template_files,
        }), 200
    except subprocess.CalledProcessError as e:
        return jsonify({"error": str(e)}), 500

@app.route("/output.png")
def get_output_png():
    """Returns the rendered PNG."""
    png_file = os.path.join(GEN_DIR, "output.png")
    if os.path.exists(png_file):
        return send_file(png_file, mimetype="image/png")
    return "No image generated.", 404

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050, debug=True)
    