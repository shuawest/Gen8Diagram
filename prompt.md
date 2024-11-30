
1) Create a python flask app
2) Keep the stylesheet in a separate file in the same directory, instead of putting it inline in the python app.
3) Keep the htlm in a separate file in the same directory, instead of putting it inline in the python app.
4) Use Patternfly javascript and stylesheets for the UI. A dark theme. Use 'Red Hat Display' as the font. Use 'Red Hat Mono' for text editors.
5) The left side should be a form with the following elements:
5a) Form row 1 - A long render button the width of the form
5b) Form row 2 - A selection box populated with all the files ending in .yaml in the working directory. Default to 'default.yaml'. A text box that allow you set a new name for the inventory when you hit render - accept only alphanumerics, dash, and underscore - defaulting to 'default'. The '.yaml' extension should be added in the python backend code. 
5c) Form row 3 - A yaml editor textbox that uses ace javascript side formatting and validation for yaml, filled with the content from the selected .yaml file. The height should be at least 200px and be resizable vertically. 
5d) Form row 4 - A selection box populated with all the files ending in '.svg.j2' in the working directory. Default to 'letter.svg.j2'. A text box that allow you set a new name for the template when you hit render - accept only alphanumerics, dash, and underscore - defaulting to 'leter'. The '.svg.j2' extension should be added in the python backend code. 
5e) Form row 5 - An SVG, XML, j2 editor textbox that uses ace javascript side formatting and validation for xml, filled with the content from the selected .svg.j2 file. The height should be at least 200px and be resizable vertically. 
6) The right size should be a white box that displays the output PNG from the inkscape render based on the input yaml and svg.j2 content. 
7) When render is clicked save the contents to the proper '.yaml' and '.svg.j2' files using the name in the corresponding text fields. 

a) The yaml editor isn't populating with the contents of the default or selected dropdown item. 
b) The svg editor isn't populating with the contents of the default or selected dropdown item.
c) The text box with the name of 'yaml' file isn't modifiable. I want to be able to create a new yaml file in the same directory, by changing this value. 
d) The text box with the name of 'svg.j2' file isn't modifiable. I want to be able to create a new 'svg.j2' file in the same directory, by changing this value. 
e) The render button isn't working. It worked prior when using the 'subprocess' python package approach.
f) The output png pane is still on the left side. I should fill the right side of the page below the header. 

The render is now working, but there are still some issues.
a) The png output pane on the right used to use an iframe, and that worked better. 
b) The contents of the default 'yaml' and 'svg.j2' files should be populated in the corresponding editors on page load. 
c) When the user hits render, the name of the selection dropdown boxes should be updated after the file is output with the new name from the name textbox. 
d) The SVG editor should use javascript based syntax highlighting and formatting at least based on XML.  If ACE can recognize both XML and jinja2 syntax that would be great. 

Now the YAML and SVG editors aren't event showing up. The left and right panels are still overlapping. As I change the item in the dropdown selectors, the name in the corresponding text box isn't updating. 
