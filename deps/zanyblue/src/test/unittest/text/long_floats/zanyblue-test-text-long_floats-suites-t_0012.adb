--
--  ZanyBlue, an Ada library and framework for finite element analysis.
--
--  Copyright (c) 2012, 2016, Michael Rohan <mrohan@zanyblue.com>
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions
--  are met:
--
--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--
--    * Neither the name of ZanyBlue nor the names of its contributors may
--      be used to endorse or promote products derived from this software
--      without specific prior written permission.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
--  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
--  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
--  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
--  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
--  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
--  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--

with ZanyBlue.Text.Locales;

separate (ZanyBlue.Test.Text.Long_Floats.Suites)
procedure T_0012 (T : in out Test_Case'Class) is

   use ZanyBlue.Text.Locales;

   ar       : constant Locale_Type := Make_Locale ("ar");
   V1       : constant Long_Float := 55.0;
   V2       : constant Long_Float := 66.1;
   V3       : constant Long_Float := -55.0;
   V4       : constant Long_Float := -66.1;
   Arg1     : constant Float_Argument_Type := +V1;
   Arg2     : constant Float_Argument_Type := +V2;
   Arg3     : constant Float_Argument_Type := Create (V3);
   Arg4     : constant Float_Argument_Type := Create (V4);

begin
   Check_Value (T, Arg1.Format ("float", "=6.2f", ar),
                   "٠٥٥.٠٠");
   Check_Value (T, Arg2.Format ("float", "=6.2f", ar),
                   "٠٦٦.١٠");
   Check_Value (T, Arg3.Format ("float", "=6.2f", ar),
                   "‎-٥٥.٠٠");
   Check_Value (T, Arg4.Format ("float", "=6.2f", ar),
                   "‎-٦٦.١٠");
end T_0012;
