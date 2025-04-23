------------------------------------------------------------------------------
--                                                                          --
--                   GNOGA - The GNU Omnificent GUI for Ada                 --
--                                                                          --
--                    G N O G A . C L I E N T . F I L E S                   --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                                                                          --
--                     Copyright (C) 2020 Pascal Pignard                    --
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

with Gnoga.Gui.Base;
with Gnoga.Gui.Blob;
with Gnoga.Gui.Element.Form;
with Gnoga.Gui.Window;

package Gnoga.Client.Files is

   --  Files API is inspired by https://developer.mozilla.org/en-US/docs/Web/API/FileReader.
   --  Some comments come from FileReader documentation.

   -------------------------------------------------------------------------
   --  File_Reader_Type
   -------------------------------------------------------------------------

   --  The FileReader object lets web applications asynchronously read the
   --  contents of files stored on the user's computer

   type File_Reader_Type is new Gnoga.Gui.Base.Base_Type with private;
   type File_Reader_Access is access all File_Reader_Type;
   type Pointer_To_File_Reader_Class is access all File_Reader_Type'Class;

   type State_Type is (Empty, Loading, Done);
   --  EMPTY    No data has been loaded yet.
   --  LOADING  Data is currently being loaded.
   --  DONE     The entire read request has been completed.
   -------------------------------------------------------------------------
   --  File_Reader_Type - Creation Methods
   -------------------------------------------------------------------------

   procedure Create
     (Reader : in out File_Reader_Type;
      Window : in     Gnoga.Gui.Window.Window_Type);
   --  Create reader associated to the user window

   -------------------------------------------------------------------------
   --  File_Reader_Type - Properties
   -------------------------------------------------------------------------

   function Error_Code
     (Reader : File_Reader_Type)
      return Integer;
   --  Return the error code that occurred while reading the file.

   function Error_Message
     (Reader : File_Reader_Type)
      return String;
   --  Return the error message that occurred while reading the file.

   function Error_Name
     (Reader : File_Reader_Type)
      return String;
   --  Return the error name that occurred while reading the file.

   function State
     (Reader : File_Reader_Type)
      return State_Type;
   --  Return the current state of the reader

   function Content
     (Reader : File_Reader_Type)
      return String;
   --  Return the current content of the reader as text

   -------------------------------------------------------------------------
   --  File_Reader_Type - Methods
   -------------------------------------------------------------------------

   procedure Transfert_Abort (Reader : in out File_Reader_Type);
   --  Aborts the read operation. Upon return, the State will be DONE.

   procedure Transfert_As_Binary
     (Reader : in out File_Reader_Type;
      Files  : in     Gnoga.Gui.Element.Form.File_Type'Class;
      Index  : in     Positive := 1);
   --  Starts reading the contents of the specified file by its index, once finished,
   --  the reader contains the raw binary data from the file as a string.

   procedure Transfert_As_Text
     (Reader   : in out File_Reader_Type;
      Files    : in     Gnoga.Gui.Element.Form.File_Type'Class;
      Index    : in     Positive := 1;
      Encoding : in     String   := "UTF-8");
   --  Starts reading the contents of the specified file by its index, once finished,
   --  the reader contains the contents of the file as a text string.
   --  An optional encoding name can be specified.

   -------------------------------------------------------------------------
   --  File_Reader_Type - Event Handlers
   -------------------------------------------------------------------------

   type File_Reader_Event is access procedure
     (Object : in out Gnoga.Gui.Base.Base_Type'Class;
      Event  : in     String);

   procedure On_Abort_Handler
     (Reader  : in out File_Reader_Type;
      Handler : in     File_Reader_Event);
   procedure Fire_On_Abort
     (Reader : in out File_Reader_Type;
      Event  : in     String);
   --  Fired when a read has been aborted, for example because the program called Transfert_Abort.

   procedure On_Error_Handler
     (Reader  : in out File_Reader_Type;
      Handler : in     File_Reader_Event);
   procedure Fire_On_Error
     (Reader : in out File_Reader_Type;
      Event  : in     String);
   --  Fired when the read failed due to an error.

   procedure On_Load_Handler
     (Reader  : in out File_Reader_Type;
      Handler : in     File_Reader_Event);
   procedure Fire_On_Load
     (Reader : in out File_Reader_Type;
      Event  : in     String);
   --  Fired when a read has completed successfully.

   procedure On_Load_End_Handler
     (Reader  : in out File_Reader_Type;
      Handler : in     File_Reader_Event);
   procedure Fire_On_Load_End
     (Reader : in out File_Reader_Type;
      Event  : in     String);
   --  Fired when a read has completed, successfully or not.

   procedure On_Load_Start_Handler
     (Reader  : in out File_Reader_Type;
      Handler : in     File_Reader_Event);
   procedure Fire_On_Load_Start
     (Reader : in out File_Reader_Type;
      Event  : in     String);
   --  Fired when a read has started.

   procedure On_Progress_Handler
     (Reader  : in out File_Reader_Type;
      Handler : in     File_Reader_Event);
   procedure Fire_On_Progress
     (Reader : in out File_Reader_Type;
      Event  : in     String);
   --  Fired periodically as data is read.

   overriding procedure On_Message
     (Reader  : in out File_Reader_Type;
      Event   : in     String;
      Message : in     String);
   --  Called on receiving any event from the reader.

   -------------------------------------------------------------------------
   --  File_Writer_Type
   -------------------------------------------------------------------------

   --  The File_Writer_Type object lets web applications write stored
   --  content to a file of the user's choosing

   type File_Writer_Type is new Gnoga.Gui.Base.Base_Type with private;
   type File_Writer_Access is access all File_Writer_Type;
   type Pointer_To_File_Writer_Class is access all File_Writer_Type'Class;

   -------------------------------------------------------------------------
   --  File_File_Writer_TypeReader_Type - Creation Methods
   -------------------------------------------------------------------------

   procedure Create
     (Writer : in out File_Writer_Type;
      Window : in     Gnoga.Gui.Window.Window_Type);
   --  Create writer associated to the user window

   -------------------------------------------------------------------------
   --  File_Writer_Type - Methods
   -------------------------------------------------------------------------

   procedure Reset_Content (Object : in out File_Writer_Type);
   --  Clears any stored data in the File_Writer_Type object

   subtype Byte       is Gnoga.Gui.Blob.Byte;
   subtype Byte_Array is Gnoga.Gui.Blob.Byte_Array;
   --  Types for raw binary data.  They are defined as:
   --     type Byte is mod 2 ** 8
   --        with Size => 8;
   --     type Byte_Array is array (Positive range <>) of Byte
   --        with Component_Size => Byte'Size;

   procedure Add_Binary_Content
      (Object  : in out File_Writer_Type;
       Content : in     Gnoga.Gui.Blob.Byte_Array);
   --  Adds raw binary content to the File_Writer_Type object, using
   --  an append operation

   procedure Add_UTF8_Content
      (Object  : in out File_Writer_Type;
       Content : in     String);
   --  Adds Gnoga.String content to the File_Writer_Type, encoded
   --  as UTF8 data, using an append operation

   procedure Write_Content_To_File
      (Object   : in File_Writer_Type;
       Filename : in String);
   --  Prompts the user to save the contents of the
   --  File_Writer_Type object, using the supplied
   --  filename as the default value.

private
   type File_Reader_Type is new Gnoga.Gui.Base.Base_Type with record
      On_Abort_Event      : File_Reader_Event := null;
      On_Error_Event      : File_Reader_Event := null;
      On_Load_Event       : File_Reader_Event := null;
      On_Load_End_Event   : File_Reader_Event := null;
      On_Load_Start_Event : File_Reader_Event := null;
      On_Progress_Event   : File_Reader_Event := null;
   end record;

   type File_Writer_Type is new Gnoga.Gui.Base.Base_Type with record
      Blob : Gnoga.Gui.Blob.Blob_Type;
   end record;
end Gnoga.Client.Files;
