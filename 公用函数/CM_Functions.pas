function GetFileVersion(FileName: string): string;
type
  PVerInfo = ^TVS_FIXEDFILEINFO;

  TVS_FIXEDFILEINFO = record
    dwSignature: longint;
    dwStrucVersion: longint;
    dwFileVersionMS: longint;
    dwFileVersionLS: longint;
    dwFileFlagsMask: longint;
    dwFileFlags: longint;
    dwFileOS: longint;
    dwFileType: longint;
    dwFileSubtype: longint;
    dwFileDateMS: longint;
    dwFileDateLS: longint;
  end;
var
  ExeNames: array[0..255] of char;
  zKeyPath: array[0..255] of Char;
  VerInfo: PVerInfo;
  Buf: pointer;
  Sz: word;
  L, Len: Cardinal;
begin
  StrPCopy(ExeNames, FileName);
  Sz := GetFileVersionInfoSize(ExeNames, L);
  if Sz = 0 then
  begin
    Result := '';
    Exit;
  end;

  try
    GetMem(Buf, Sz);
    try
      GetFileVersionInfo(ExeNames, 0, Sz, Buf);
      if VerQueryValue(Buf, '\', Pointer(VerInfo), Len) then
      begin
        Result := IntToStr(HIWORD(VerInfo.dwFileVersionMS)) + '.' + IntToStr(LOWORD(VerInfo.dwFileVersionMS)) + '.' + IntToStr(HIWORD(VerInfo.dwFileVersionLS)) + '.' + IntToStr(LOWORD(VerInfo.dwFileVersionLS));

      end;
    finally
      FreeMem(Buf);
    end;
  except
    Result := '-1';
  end;
end;