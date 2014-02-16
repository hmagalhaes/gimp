[em português](README.pt.md)

Gimp Websprites
====
Scripts to help you create CSS web sprites and reduce the number HTTP requests on your website.

###1. Features###
Script-fu package with three scripts, including:
* CSS file exporting to use the web sprite;
* Horizontal layers arrangement, side by side;
* Vertical layers arrangement, one on top of the other.

![plugin workflow](logo.png)

###2. Menu###
The scripts can be accessed by the following menus:
* Image/Web Sprites/Arrange layers horizontally
* Image/Web Sprites/Arrange layers vertically
* Image/Web Sprites/Export CSS file

###3. Arrangement scripts###
These scripts will simple reposition every layer in horizontal or vertical organisation and then will resize the canvas size to fit those layers.  
Whenever possible, prefer to use horizontal arrangement because it will result in smaller image files.

###4. Exportation script###

######4.1. CSS selectors######
The resulting CSS selectors will be named after each image layer name. It means, if you want a layer to be exported as "div.icon", you should name it the same.

######4.2 Options######
By executing the exportation script, a dialog box will open with all available options for the file creation. The options are the following:

Option | Description |
-------|-------------|
CSS file (output file) | Type here the CSS file name.
CSS file directory | Directory to save the CSS file.
Image file (bkg-image) | Image/sprite name which will be used on CSS (eg.: the image exported to PNG). 
Selectors prefix | Prefix to add to each CSS selector. Eg.: You are making a menu where each item is a "li" and its identified by an CSS class, then set it as "li.". By doing so, a layer named "home" will result on a selector "li.home".
Selectors postfix | Postfix to add to each CSS selector. Eg.: Following the above example, set it as " > span" to have as result "li.home > span".
Bkg Repeat | Value of "background-repeat" to include. In case of you don't want it to be setted, chose the option "Leave it Blank!".
Abstraction selector | Use it to reduce redundancy in the CSS file. Eg.: You are making a menu where each item is a "li", then set is as "li.". By doing so, properties like "background-image" will be setted only in this abstraction instead of in each selector.
Group up selectors | Enable it to group up selectors in one unique rule to set things like "background-image" just once, and reduce CSS redundancy. Use it when it's not possible to use the abstraction selector.
Include layer width | Include each layer's width in the CSS.
Include layer height | Include each layer's height in the CSS.
Set scale in group/abstraction | Use this to have width and height defined only on the selectors grouping or on the abstraction selector. It can be used when all the layers have the same dimensions.
Keep white spaces | Disable it to remove all non mandatory white spaces.
Keep line breaks | Disable it to remove all non mandatory line breaks (all of them).
Remove file extension | Disable it if you don't want that the files extensions, in the layers names get removed. Just remember that dots in CSS have and specific mean and can't be part of a selector's identifier.
