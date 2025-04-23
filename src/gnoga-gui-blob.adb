with Gnoga.Server.Connection;
with UXStrings;

package body Gnoga.Gui.Blob is

   ------------------------
   -- Utility Operations --
   ------------------------

   Default_MIME_Type : constant String := "application/octet-stream";
   --  Default mime type for underlying storage.  Can change this by
   --  recreating the Blob with a new mime type

   function New_Blob
      (Content   : String;
       MIME_Type : String := Default_MIME_Type)
       return String;
   --  Helper function to generate Javascript for a new Blob

   function New_Blob
      (Content   : String;
       MIME_Type : String := Default_MIME_Type)
       return String
   is ("new Blob([" & Content & "],{type: '" & MIME_Type & "'})");

   generic
      type Element_Type is (<>);
      type Index_Type is (<>);
      type Array_Type is array (Index_Type range <>) of Element_Type;
   function New_Uint8Array (Items : Array_Type) return String;
   --  Generic converison operation that creates a Javascript
   --  Uint8Array object from the supplied Ada array.  Objects
   --  of type Element_Type must only be in the range of values
   --  in type Byte

   function New_Uint8Array (Items : Array_Type) return String is

      function Pos_Image (Item : Element_Type) return String is
         (UXStrings.From_ASCII (Byte'Image (Element_Type'Pos (Item))));
      --  Generates a Gnoga.String representation of the Pos value of
      --  the byte located at Items(Index)

   begin
      return Result : String := "new Uint8Array([" do

         --  Iterate through all bytes, adding them as their
         --  numeric values to avoid needing to escape anything
         for Index in Items'Range loop
            if Index = Items'Last then
               Result.Append (Pos_Image (Items (Index)));
            else
               Result.Append (Pos_Image (Items (Index)) & ",");
            end if;
         end loop;

         Result.Append ("])");

      end return;
   end New_Uint8Array;

   function From_Binary is new New_Uint8Array
      (Element_Type => Byte,
       Index_Type   => Positive,
       Array_Type   => Byte_Array);
   --  Generic instantiation for byte arrays

   function From_UTF8 is new New_Uint8Array
      (Element_Type => Character,
       Index_Type   => Positive,
       Array_Type   => UXStrings.UTF_8_Character_Array);
   --  Generic instantiation for UTF8 arrays

   ------------
   -- Create --
   ------------

   procedure Create
      (Blob          : in out Blob_Type;
       Connection_ID : in     Gnoga.Types.Connection_ID;
       ID            : in     String := "")
   is
      GID : constant String :=
         (if ID = "" then
            Gnoga.Server.Connection.New_GID
          else
            ID);
      Script : constant String := "gnoga['" & GID & "']=" & New_Blob ("");
   begin
      --  Gnoga.Log (Script);
      Blob.Create_With_Script
         (Connection_ID => Connection_ID,
          ID            => GID,
          Script        => Script,
          ID_Type       => Gnoga.Types.Gnoga_ID);
   end Create;

   ---------------------
   -- Script_Accessor --
   ---------------------

   overriding
   function Script_Accessor (Object : Blob_Type) return String is
      (Gnoga.Gui.Base.Base_Type (Object).Script_Accessor);

   -------------------------
   -- Assign_As_MIME_Type --
   -------------------------

   function Assign_As_MIME_Type
      (Object    : Blob_Type;
       MIME_Type : String)
       return String
   is (New_Blob (Object.Script_Accessor, MIME_Type));

   -------------------
   -- Reset_Content --
   -------------------

   procedure Reset_Content (Object : in out Blob_Type) is
      Self   : constant String := Object.Script_Accessor;
      Script : constant String := Self & "=" & New_Blob ("");
   begin
      --  Gnoga.Log (Script);
      Gnoga.Server.Connection.Execute_Script
         (ID     => Object.Connection_ID,
          Script => "(function(){" & Script & ";})();");
   end Reset_Content;

   ------------------------
   -- Add_Binary_Content --
   ------------------------

   procedure Add_Binary_Content
      (Object  : in out Blob_Type;
       Content : in     Byte_Array)
   is
      Self   : constant String := Object.Script_Accessor;
      Script : constant String := Self & "=" & New_Blob (Self & "," & From_Binary (Content));
   begin
      --  Gnoga.Log (Script);
      Gnoga.Server.Connection.Execute_Script
         (ID     => Object.Connection_ID,
          Script => "(function(){" & Script & ";})();");
   end Add_Binary_Content;

   ----------------------
   -- Add_UTF8_Content --
   ----------------------

   procedure Add_UTF8_Content
      (Object  : in out Blob_Type;
       Content : in     String)
   is
      Self   : constant String := Object.Script_Accessor;
      Script : constant String := Self & "=" & New_Blob (Self & "," & From_UTF8 (Content.To_UTF_8));
   begin
      --  Gnoga.Log (Script);
      Gnoga.Server.Connection.Execute_Script
         (ID     => Object.Connection_ID,
          Script => "(function(){" & Script & ";})();");
   end Add_UTF8_Content;

end Gnoga.Gui.Blob;