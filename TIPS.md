#TIPS

Many tips will be found also in source code specification for types and subprograms.

1. Want to take an HTML snapshot of your page:
    ```
    Gnoga.Server.Template_Parser.Write_String_To_File
    ("site.html", Main_Window.Document.Document_Element.Outer_HTML);
    ```

1. Use View.Hidden to remove from browser, then View.Remove to remove from DOM. When View finalizes on the Ada side it will also tell the browser to reclaim the elements memory as well.

1. How do I add scrollbars to a view?<BR>
Set View.Overflow or View.Overflow\_X or View.Overflow\_Y with Visible, Hidden, Scroll, Auto.

1. When using the Grid view you always get best results when placing Views in to the grids instead of using the individual cell directly. When encapsulating what you want in to another container (especially if its size is known) will get a more predictable layout of the underlying table.

1.  If I create an object dynamically and add it to the DOM via create on a parent. If I later free that object manually and replace it with a newly created version (still set to dynamic), does that cause any memory leaks?
If you free the memory Ada's runtime will finalize the object which will remove any references to it in the Gnoga cache on the browser side. If you leaving "dangling pointer" on the Ada side you will of course have a leak. (Unless of course they were marked dynamic before creation and so the parent Gnoga view has a reference and will deallocate it when it finalizes)

1. Does the DOM remember every object I add to a parent or will freeing it remove it completely from the DOM?<BR>
On the browser side elements created by the Gnoga framework have a reference in a global cache called gnoga[]. When the Gnoga object on the Ada side is finalized, the reference in the cache is removed. As long as that element is not in the DOM the browser will release the object's memory as part of its garbage collection on the browser side.

1. Would something like this cause any problems (memory leak or otherwise)?<BR>
If you are using dynamic you shouldn't be deallocating manually. If you do then when the garbage collection starts with App.Console is finalized it will try to deallocate already deallocated blocks of memory.
Unless you have extreme memory constraints, just overwrite the pointer since the parent view will take care of things or do not use dynamic and deallocate on connection close.

1. Use Gnoga.Server.Connection.Execute\_Script for raw JS execution (there is both a procedure and function version). You can get the Connection ID from any object on a connection (View.Connection\_ID, etc).

1. To define at connection time the window Title and the closed connection message use Main_Window.Document.Title and Gnoga.Server.Connection.HTML\_On\_Close.

1. In general if you find yourself needing to use Unrestricted_Access you are likely going to have issues. For the "tutorials" it was used since it was wanted to keep everything to a single procedure, etc. but perhaps was not the smartest thing to have laying around. Try and keep handlers at package level when possible is a good principle to live by.

1. How do I get a hold on a child element, on the gnoga side, knowing its ID?<BR>
`    My_Button.Attach_Using_Parent (View, ID => "my_button");`

1. Try setting any callbacks to null before deleting visual elements, that would remove any race conditions.

1. There is no way to prevent the user to close the browser window.

1. An On\_Submit\_Handler is set in the table widget. It gets called for the submit buttons. How to access anything in the handler that lets me know what row the submit button was on and how to access the view data structure for the row?
You will need to add an On\_Focus handler to the forms, you can write a single handler and just attach to all the widgets. Have it store the ID or a pointer to the last focused widget. The browser doesn't store or report the focus so no other way to get it.

1. Just freeing an object on the Gnoga side will not remove it from the DOM, that is intended. You need to call Remove first.

1. To avoid two visual elements to disappear and then reappear, somewhat slowly and flickering. Create visual element that is hidden. Fill it in. Hide first and show second. Can either delete the old one or recycle it.

1. Colors in Gnoga.Types.Colors can be displayed or chosen from [www.w3schools.com/cssref/css_colors.asp](https://www.w3schools.com/cssref/css_colors.asp) or [www.w3schools.com/colors/colors_picker.asp](https://www.w3schools.com/colors/colors_picker.asp).

1. Want to see what is going on in the browser console ?<BR>
Turn debug on in your boot page <script>var gnoga_debug = true;</script> or use debug.html.

1. Trying to use Connection\_Data in a handler bounded to On\_Destroy\_Handler did not work when closing the browser window because at that point Object.Connection\_Data returns null.
Use instead On\_Before\_Unload\_Handler. Note: it is not effective when only closing the connection.

1. How about reloading the whole page when On\_Resize is called?<BR>
Call `Main_Window.Location.Reload`.

1. If the user clicks the refresh button on the browser, it breaks the connection and creates a new one. This is extremely annoying, since the program starts over from scratch.
Refresh implies a lost connection and new session on web browsers, that is expected functionality. Local storage could be used on the browser side (Gnoga.Client.Storage) to store session information or any other data on the client side and use that data after a refresh or even weeks later to restore them to some state in your software.

1. `HTML_On_Close` text is displayed only when connection is broken and not when connection is closed. In order to display some text before closing connection, remove current view, create a new one with your text and then close connection, for instance:
    ```
    App.My_View.Remove;
    View.Create (App.My_Window.all);
    View.Put_Line ("Application exited.");
    App.My_Window.Close_Connection;
    ```

1. You want to browse through Gnoga API, generate them with gnatdoc:
    ```
    $ make rm-docs
    $ open docs/html/gnoga_rm/index.html
    ```

1. Command "make" alone or "make help" prints main make targets and make environnement variables.

1. How to create a button of a specified size?<BR>
`    Button.Create (Parent => Parent, Content => Content);`<BR>
    creates a button of the default size for Content, with a thin border with rounded corners. Adding
    ```
    Button.Box_Width  (Value => Button_Size);
    Button.Box_Height (Value => Button_Size);
    ```
    has no effect. But also adding<BR>
`    Button.Border;`<BR>
    results in a button of the desired size, with a fairly thick, black border with square corners. Adding (Width => "thin") to the call to Border may be desirable.

1. How do I add a class attribute to an element in code?<BR>
Use the class property:<BR>
`    Gnoga.Gui.Element.Class`
    which replaces all class with the value of Class or the method or
`    Gnoga.Gui.Element.Add_Class`
    which will add a class but not remove other classes that may already apply to the element.

1. Take care of latency, many subprograms do query the client side and wait for an answer, so they can be very slow if server and client are far from each other!

1. How can I play a file not in the current directory?<BR>
Gnoga recognizes executable in bin (if exist) directory and thus sets its root directory for relative paths and then same for html, img directories and so on if they exist. The browser generally only has access to files you can serve  ie in your app directory. Your app though using normal Ada code has access as usual to everything. You could copy the file into the html directory play it and then clear it.

1. When giving this URL: `http://127.0.0.1:8080/toto?m=a&l=b#ici`<BR>
Why do I receive?<BR>
`    2017-09-17 11:31:07.56 : Kind: FILE, File: toto, Query: m=a&l=b`<BR>
Because HTML browser sends just:<BR>
`    GET /toto?m=a&l=b HTTP/1.1`<BR>
which turns to become File.

1. How to keep label of GUI elements accessible in event handlers?<BR>
Create a labelled element as for instance:
    ```
    type Labeled_Range_Type is new Gnoga.Gui.Element.Form.Range_Type with record
       Label : Gnoga.Gui.Element.Form.Label_Type;
    end record;
    ```
    Use it as:
    ```
    procedure On_Range_Change (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
    begin
         Labeled_Range_Type (Object).Label.Text
         (Labeled_Range_Type (Object).Value);
    end On_Range_Change;
    ```

1. You want to browse through Gnoga API, generate them with gnatdoc:
    ```
    $ make rm-docs
    $ open obj/gnatdoc/index.html
    ```

1. The way to get window title and on close message to be localized at connection time is to add the following code in your On_Connect subprogram:
    - Get the browser language
    - Make a Zanyblue locale with it and the encoding Latin-1 for Ada String type
    - Change title and on close message via direct API with previous locale and localized messages from Zanyblue

    Example:
    ```
    Page.Locale := ZanyBlue.Text.Locales.Make_Locale_Narrow (Gnoga.Gui.Navigator.Language (Main_Window) & ".ISO8859-1");
    Main_Window.Document.Title (Format_TITL (Page.Locale));
    Gnoga.Server.Connection.HTML_On_Close (Main_Window.Connection_ID, Format_APPE (Page.Locale));
    ```

1. If sqlite is not provided by your system, just do:<BR>
`make sqlite3`

1. Static web contents (HTML pages, images) are served regardless of the existence of a "formal" connection processed by 
On_Connect as for instance with `http://127.0.0.1:8080/toto.html` or with a HTML URL embedded in HTML code. Gnoga is an HTTP server at first. Files are searched in html folder, if not existent then default boot file is served. Files may be located in img, css or js folders but folder names have to be explicitly present in the URL as for instance `http://127.0.0.1:8080/img/E4a.png`.

1. Host, port, boot file and verbosity programmed in source code may be overriden at server side on the command line.
Use the following command line options: `--gnoga-host=<host name> --gnoga-port=<port value> --gnoga-boot=<boot file name> --gnoga-verbose=<true or false>`.<BR>
Example: `% ./bin/cli --gnoga-verbose=false --gnoga-port=8082`

1. How to disable/enable connections to the server? The On_Connect handler simply must do nothing. Once that handler completes the connection is dropped, but not refused. You can also use it to display a message regarding the status.

1. Recent browsers like Firefox block Javascript execution with alert popup and prevent to answer Gnoga server which issues a timeout exception. By default the timeout value is 3 s. You must thus close the popup before to avoid exceptions. Alert popup should be avoided.

1. A good practice is to register all connection data outside of On_Connect handler with Connection_Data.
Otherwise as On_Connect local data are deallocated when On_Connect ends,
the connection may crash for instance when resizing the window because the View data no longueur exist.

1. User defined logging is supported: declare a type inherited from Gnoga.Loggings.Root_Logging_Type and redefined the 3 forms of log:
    - `procedure Log (Object : Root_Logging_Type; Message : in String);`
    - `procedure Log (Object : Root_Logging_Type; Occurrence : in Ada.Exceptions.Exception_Occurrence);`
    - `procedure Log (Object : Root_Logging_Type; Message : in String; Occurrence : in Ada.Exceptions.Exception_Occurrence);`

    See example in tests/user_defined_logging.ads (only one form of log is redefined from Gnoga.Loggings.Console_Logging_Type)

1. next tip...
