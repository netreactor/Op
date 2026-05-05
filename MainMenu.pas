program Main;

uses Crt, HVmenu, Stack1Lib, queu, StudentFileLib, StudentFile2;

var
  RootMenu: PtrHoriz;
  Choice: Integer;
  ExitProgram: Boolean;
  InputStr: String;
  Code: Integer;
  S1: Ptr;
  QLeft, QRight: PtrQ;

begin
  RootMenu := nil;
  S1 := Nil;
  QLeft := nil;
  QRight := nil;
  ExitProgram := False;

  repeat
    ClrScr;
    TextColor(White);
    WriteLn('=== Главное меню ===');
    WriteLn('1. Стэк');
    WriteLn('2. Стэк студенты');
    WriteLn('3. Очередь');
    WriteLn('4. Студенты файл');
    WriteLn('5. Студенты файл 2');
    WriteLn('0. Выход');
    WriteLn('--------------------');
    Write('Выберите (0-5): ');

    ReadLn(InputStr);
    Val(InputStr, Choice, Code);
    if Code <> 0 then
      Choice := -1;

    case Choice of
      1:
        begin
          DrawInterfacel1(S1);
        end;
      2:
        DrawInterfacel2();
      3:
        DrawInterfaceQueu(QLeft, QRight);
      4:
        DrawInterfaceStudentFile;
      5:
        DrawInterfaceStudentFile2;
      0:
        ExitProgram := True;
    else
      begin
        WriteLn('Неверный пункт. Нажмите Enter...');
        ReadLn;
      end;
    end;

  until ExitProgram;
end.

