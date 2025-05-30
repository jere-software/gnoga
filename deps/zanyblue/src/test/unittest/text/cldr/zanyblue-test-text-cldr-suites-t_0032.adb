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

separate (ZanyBlue.Test.Text.CLDR.Suites)
procedure T_0032 (T : in out Test_Case'Class) is

   ja : constant Locale_Type := Make_Locale ("ja");

   procedure Check_Language (Abbreviation : String;
                             Value        : String);

   procedure Check_Language (Abbreviation : String;
                             Value        : String) is
   begin
      Check_Value (T, Language_Name (Abbreviation, Locale => ja), Value,
                      "Mis-match for " & Abbreviation);
   end Check_Language;

begin
   if not Is_Locale_Defined ("ja", "", "") then
      WAssert (T, True, "JA localization not included");
      return;
   end if;
   Check_Language ("aa", "アファル語");
   Check_Language ("ba", "バシキール語");
   Check_Language ("ca", "カタロニア語");
   Check_Language ("da", "デンマーク語");
   Check_Language ("ee", "エウェ語");
   Check_Language ("fa", "ペルシア語");
   Check_Language ("ga", "アイルランド語");
   Check_Language ("ha", "ハウサ語");
   Check_Language ("ia", "インターリングア");
   Check_Language ("ja", "日本語");
   Check_Language ("ka", "グルジア語");
   Check_Language ("la", "ラテン語");
   Check_Language ("mad", "マドゥラ語");
   Check_Language ("na", "ナウル語");
   Check_Language ("oc", "オック語");
   Check_Language ("pa", "パンジャブ語");
   Check_Language ("qu", "ケチュア語");
   Check_Language ("raj", "ラージャスターン語");
   Check_Language ("sa", "サンスクリット語");
   Check_Language ("ta", "タミル語");
   Check_Language ("udm", "ウドムルト語");
   Check_Language ("vai", "ヴァイ語");
   Check_Language ("wa", "ワロン語");
   Check_Language ("xal", "カルムイク語");
   Check_Language ("yao", "ヤオ語");
   Check_Language ("za", "チワン語");
end T_0032;
