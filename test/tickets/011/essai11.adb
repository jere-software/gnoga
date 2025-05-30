with Ada.Characters.Conversions;

with Gnoga.Application.Singleton;
with Gnoga.Gui.Window;
with Gnoga.Gui.View.Console;
with Gnoga.Gui.View.Grid;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.Base;

with UXStrings.Conversions;

procedure Essai11 is
   use Gnoga;
   use Gnoga.Gui.View.Grid;
   use all type Gnoga.String;

   Main_Window : Gnoga.Gui.Window.Window_Type;

   Layout_View : Gnoga.Gui.View.Grid.Grid_View_Type;
   Text_View   : Gnoga.Gui.View.View_Type;
   --  Gnoga.Gui.View.Console.Console_View_Type;
   Quit_Button : Gnoga.Gui.Element.Common.Button_Type;

   procedure On_Quit (Object : in out Gnoga.Gui.Base.Base_Type'Class);
   procedure On_Key_Char_Event
     (Object : in out Gnoga.Gui.Base.Base_Type'Class;
      Key    : in     Character);
   procedure On_Key_Press_Event
     (Object         : in out Gnoga.Gui.Base.Base_Type'Class;
      Keyboard_Event : in     Gnoga.Gui.Base.Keyboard_Event_Record);

   procedure On_Quit (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      pragma Unreferenced (Object);
   begin
      Gnoga.Application.Singleton.End_Application;
   end On_Quit;

   procedure On_Key_Char_Event
     (Object : in out Gnoga.Gui.Base.Base_Type'Class;
      Key    : in     Character)
   is
      pragma Unreferenced (Object);
   begin
      Text_View.Put (From_Latin_1 (Key));
   end On_Key_Char_Event;

   procedure On_Key_Press_Event
     (Object         : in out Gnoga.Gui.Base.Base_Type'Class;
      Keyboard_Event : in     Gnoga.Gui.Base.Keyboard_Event_Record)
   is
      pragma Unreferenced (Object);
      function Image is new UXStrings.Conversions.Scalar_Image (Gnoga.Gui.Base.Keyboard_Message_Type);
   begin
      Gnoga.Log
        (Image (Keyboard_Event.Message) &
         ',' &
         Keyboard_Event.Key &
         ',' &
         Image (Keyboard_Event.Key_Code) &
         ',' &
         Ada.Characters.Conversions.To_Wide_Wide_Character (Keyboard_Event.Key_Char) &
         ',' &
         Image (Keyboard_Event.Alt) &
         ',' &
         Image (Keyboard_Event.Control) &
         ',' &
         Image (Keyboard_Event.Shift) &
         ',' &
         Image (Keyboard_Event.Meta));
   end On_Key_Press_Event;

begin
   Gnoga.Application.Title ("Keyboard tester");
   Gnoga.Application.HTML_On_Close
     ("<b>Connection to Application has been terminated</b>");

--     Gnoga.Application.Open_URL ("http://127.0.0.1:8080");
   Gnoga.Application.Singleton.Initialize (Main_Window, Port => 8080);

   Layout_View.Create
     (Parent => Main_Window, Layout => ((1 => COL), (1 => COL)));

   Quit_Button.Create (Layout_View.Panel (1, 1).all, "Quit");
   Quit_Button.On_Click_Handler (On_Quit'Unrestricted_Access);

   Text_View.Create (Layout_View.Panel (2, 1).all);
   Text_View.Fill_Parent;
   Text_View.Border;

   Text_View.Put_Line ("Keyboard characters:");
   Text_View.Tab_Index (2);
   --  Inorder to receive keyboard events, Tab_Index must be set on a view.

   Text_View.On_Key_Down_Handler (On_Key_Press_Event'Unrestricted_Access);
   Text_View.On_Key_Press_Handler (On_Key_Press_Event'Unrestricted_Access);
   Text_View.On_Key_Up_Handler (On_Key_Press_Event'Unrestricted_Access);
   Text_View.On_Character_Handler (On_Key_Char_Event'Unrestricted_Access);

   Gnoga.Application.Singleton.Message_Loop;
exception
   when E : others =>
      Gnoga.Log (E);
end Essai11;
