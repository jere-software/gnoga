pragma Ada_2022;

with Gnoga;
with Gnoga.Gui.Window;
with Gnoga.Gui.View;
with Gnoga.Gui.Element.Common;
with Gnoga.Client.Files;
with Gnoga.Application.Singleton;
with Gnoga.Gui.Base;
with Gnoga.Server;
with UxStrings;

with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Directories;

-- Program entry point
procedure File_Writer is
   Window : Gnoga.Gui.Window.Window_Type;
   View   : Gnoga.Gui.View.View_Type;
   Button : Gnoga.Gui.Element.Common.Button_Type;
   Writer : Gnoga.Client.Files.File_Writer_Type;
   package Gui renames Gnoga.Application.Singleton;
   package App renames Gnoga.Application;

   Flag : Boolean := False;

   Text : constant String := "Welcome To Gnoga";
   Binary : constant Gnoga.Client.Files.Byte_Array := [for Item of Text => Character'Pos(Item)];

   procedure On_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class) is
   begin
      if Flag then
         Writer.Reset_Content;
      else
         Writer.Add_Binary_Content(Binary);
      end if;
      Flag := not Flag;
      Writer.Write_Content_To_File("test.txt");
   end On_Click;

   Bad_Button : Gnoga.Gui.Element.Common.Button_Type;
   Bad_Anchor : Gnoga.Gui.Element.Common.A_Type;
   Count : Positive := 1;

   File_Path : constant String := Gnoga.Server.HTML_Directory.To_ASCII;
   File_Name : constant String := "test.txt";

   procedure On_Bad_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      use all type Gnoga.String;
      File : Ada.Text_IO.File_Type;
   begin
      Gnoga.Log(Gnoga.Server.HTML_Directory & UxStrings.From_ASCII(File_Name));
      if Ada.Directories.Exists(File_Path & File_Name) then
         Ada.Text_IO.Open(File, Ada.Text_IO.Out_File, File_Path & File_Name);
      else
         Ada.Text_IO.Create(File, Ada.Text_IO.Out_File, File_Path & File_Name);
      end if;
      Ada.Text_IO.Put_Line(File, "Count =" & Count'Image);
      Ada.Text_IO.Close(File);
      Count := Count + 1;
      Bad_Anchor.Click;
   exception
      when E : others => 
         Gnoga.Log(UxStrings.From_ASCII("Exception: " & Ada.Exceptions.Exception_Message(E)));
   end On_Bad_Click;
begin
   
   Gui.Initialize(Window, "127.0.0.1", 8081);

   View.Create(Window);
   Button.Create(View, "Click Me");
   Writer.Create(Window);
   Writer.Add_UTF8_Content("Hello World!");
   Writer.Add_UTF8_Content(" How are You doing? ");

   Button.On_Click_Handler(On_Click'Unrestricted_Access);

   Gnoga.Log(Writer.Script_Accessor);

   View.New_Line;
   Bad_Button.Create(View, "File Locks After First Time");
   Bad_Anchor.Create
      (Parent => View,
       Link   => UxStrings.From_ASCII(File_Name));
   Bad_Anchor.Property("download", UxStrings.From_ASCII(File_Name));
   Bad_Button.On_Click_Handler(On_Bad_Click'Unrestricted_Access);

   Gui.Message_Loop;
end File_Writer;