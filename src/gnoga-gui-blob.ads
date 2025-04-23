private with Gnoga.Gui.Base;

with Gnoga.Types;

package Gnoga.Gui.Blob is
--  Provides an interface for a Javascript Blob object

   -------------------------------------------------------------------------
   --  Blob_Type
   -------------------------------------------------------------------------

   type Blob_Type is tagged limited private;
   --  The Blob object lets applications store raw binary
   --  data that can be interpreted via different MIME types

   -------------------------------------------------------------------------
   --  Blob_Type - Creation Methods
   -------------------------------------------------------------------------

   procedure Create
      (Blob          : in out Blob_Type;
       Connection_ID : in     Gnoga.Types.Connection_ID;
       ID            : in     String := "");
   --  Create a Blob object on Connection ID.

   -------------------------------------------------------------------------
   --  Blob_Type - Javascript Interface Methods
   -------------------------------------------------------------------------

   function Script_Accessor (Object : Blob_Type) return String;
   --  Returns the script representation of the Blob variable
   --  name

   function Assign_As_MIME_Type
      (Object    : Blob_Type;
       MIME_Type : String)
       return String;
   --  Returns a copy of the Blob interpreted as the specified MIME type
   --  in a form used for the right side of an assignment in Javascript.
   --  A list of valid MIME types can be found at
   --  https://mimetype.io/all-types
   --
   --  EXAMPLE USAGE:
   --    Self   : constant String := Object.Script_Accessor;
   --    Value  : constant String := Object.Assign_As_MIME_Type("text/plain");
   --    Script : constant String := Self & "=" & Value;

   -------------------------------------------------------------------------
   --  Blob_Type - Methods
   -------------------------------------------------------------------------

   procedure Reset_Content (Object : in out Blob_Type);
   --  Clears any stored data in the Blob object

   type Byte is mod 2 ** 8
      with Size => 8;
   type Byte_Array is array (Positive range <>) of Byte
      with Component_Size => Byte'Size;
   --  Type for raw binary data (the underlying Blob content)

   procedure Add_Binary_Content
      (Object  : in out Blob_Type;
       Content : in     Byte_Array);
   --  Adds raw binary content to the Blob object, using
   --  an append operation

   procedure Add_UTF8_Content
      (Object  : in out Blob_Type;
       Content : in     String);
   --  Adds Gnoga.String content to the Blob, encoded
   --  as UTF8 data, using an append operation

private

   type Blob_Type is new Gnoga.Gui.Base.Base_Type with null record;

end Gnoga.Gui.Blob;