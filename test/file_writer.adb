pragma Ada_2022;

with Gnoga;
with Gnoga.Gui.Window;
with Gnoga.Gui.View;
with Gnoga.Gui.Element.Common;
with Gnoga.Client.Files;
with Gnoga.Application.Singleton;
with Gnoga.Gui.Base;

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
begin
   
   Gui.Initialize(Window, "127.0.0.1", 8081);

   View.Create(Window);
   Button.Create(View, "Click Me");
   Writer.Create(Window);
   Writer.Add_UTF8_Content("Hello World!");
   Writer.Add_UTF8_Content(" How are You doing? ");

   Button.On_Click_Handler(On_Click'Unrestricted_Access);

   Gnoga.Log(Writer.Script_Accessor);

   Gui.Message_Loop;
end File_Writer;