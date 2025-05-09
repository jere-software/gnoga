------------------------------------------------------------------------------
--                                                                          --
--                   GNOGA - The GNU Omnificent GUI for Ada                 --
--                                                                          --
--              G N O G A . G U I . E L E M E N T . C A N V A S             --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                                                                          --
--                     Copyright (C) 2014 David Botton                      --
--                                                                          --
--  This library is free software;  you can redistribute it and/or modify   --
--  it under terms of the  GNU General Public License  as published by the  --
--  Free Software  Foundation;  either version 3,  or (at your  option) any --
--  later version. This library is distributed in the hope that it will be  --
--  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                    --
--                                                                          --
--  As a special exception under Section 7 of GPL version 3, you are        --
--  granted additional permissions described in the GCC Runtime Library     --
--  Exception, version 3.1, as published by the Free Software Foundation.   --
--                                                                          --
--  You should have received a copy of the GNU General Public License and   --
--  a copy of the GCC Runtime Library Exception along with this program;    --
--  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see   --
--  <http://www.gnu.org/licenses/>.                                         --
--                                                                          --
--  As a special exception, if other files instantiate generics from this   --
--  unit, or you link this unit with other files to produce an executable,  --
--  this  unit  does not  by itself cause  the resulting executable to be   --
--  covered by the GNU General Public License. This exception does not      --
--  however invalidate any other reasons why the executable file might be   --
--  covered by the  GNU Public License.                                     --
--                                                                          --
--  For more information please go to http://www.gnoga.com                  --
------------------------------------------------------------------------------

with Gnoga.Server.Connection;

package body Gnoga.Gui.Element.Canvas is

   --------------
   -- Finalize --
   --------------

   overriding procedure Finalize (Object : in out Context_Type) is
   begin
      Gnoga.Server.Connection.Execute_Script (Object.Connection_ID, "delete gnoga['" & Object.Context_ID & "'];");
   exception
      when E : Gnoga.Server.Connection.Connection_Error =>
         Log ("Connection" & Image (Object.Connection_ID) & " error during delete object " & Object.Context_ID);
         Log (E);
   end Finalize;

   ------------
   -- Create --
   ------------

   procedure Create
     (Canvas : in out Canvas_Type;
      Parent : in out Gnoga.Gui.Base.Base_Type'Class;
      Width  : in     Integer;
      Height : in     Integer;
      ID     : in     String := "")
   is
   begin
      Canvas.Create_From_HTML (Parent, "<canvas width=" & Image (Width) & " height =" & Image (Height) & ">", ID);
   end Create;

   -------------------
   -- Connection_ID --
   -------------------

   function Connection_ID
     (Context : Context_Type)
      return Gnoga.Types.Connection_ID
   is
   begin
      return Context.Connection_ID;
   end Connection_ID;

   --------
   -- ID --
   --------

   function ID
     (Context : Context_Type)
      return String
   is
   begin
      return Context.Context_ID;
   end ID;

   --------------
   -- Property --
   --------------

   procedure Property
     (Context : in out Context_Type;
      Name    : in     String;
      Value   : in     String)
   is
   begin
      Context.Execute (Name & "='" & Escape_Quotes (Value) & "';");
   end Property;

   procedure Property
     (Context : in out Context_Type;
      Name    : in     String;
      Value   : in     Integer)
   is
   begin
      Context.Execute (Name & "=" & Image (Value) & ";");
   end Property;

   procedure Property
     (Context : in out Context_Type;
      Name    : in     String;
      Value   : in     Boolean)
   is
   begin
      Context.Execute (Name & "=" & Image (Value) & ";");
   end Property;

   procedure Property
     (Context : in out Context_Type;
      Name    : in     String;
      Value   : in     Float)
   is
   begin
      Context.Execute (Name & "=" & Image (Value) & ";");
   end Property;

   function Property
     (Context : Context_Type;
      Name    : String)
      return String
   is
   begin
      return Context.Execute (Name);
   end Property;

   function Property
     (Context : Context_Type;
      Name    : String)
      return Integer
   is
   begin
      return Value (Context.Property (Name));
   exception
      when E : others =>
         Log ("Error Property converting to Integer (forced to 0).");
         Log (E);
         return 0;
   end Property;

   function Property
     (Context : Context_Type;
      Name    : String)
      return Boolean
   is
      function Value is new UXStrings.Conversions.Scalar_Value (Boolean);
   begin
      return Value (Context.Property (Name));
   exception
      when E : others =>
         Log ("Error Property converting to Boolean (forced to False).");
         Log (E);
         return False;
   end Property;

   function Property
     (Context : Context_Type;
      Name    : String)
      return Float
   is
   begin
      return Value (Context.Property (Name));
   exception
      when E : others =>
         Log ("Error Property converting to Float (forced to 0.0).");
         Log (E);
         return 0.0;
   end Property;

   -------------
   -- Execute --
   -------------

   procedure Execute
     (Context : in out Context_Type;
      Method  :        String)
   is
   begin
      Gnoga.Server.Connection.Execute_Script
        (ID => Context.Connection_ID, Script => "gnoga['" & Context.ID & "']." & Method);
   end Execute;

   function Execute
     (Context : Context_Type;
      Method  : String)
      return String
   is
   begin
      return
        Gnoga.Server.Connection.Execute_Script
          (ID => Context.Connection_ID, Script => "gnoga['" & Context.ID & "']." & Method);
   end Execute;
end Gnoga.Gui.Element.Canvas;
