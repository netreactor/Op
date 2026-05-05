unit StudentFile2;

interface

uses crt, System.IO;

procedure MakeAndAddText;
procedure ViewText;
procedure BadBoys(x: byte);
procedure BadBoysTwo;
procedure DrawInterfaceStudentFile2;

implementation


//удаление пробелов
function MyWrite(Stroka: string): string;
var
  i, k: integer;
begin
  Result := Stroka;
  k := Length(Result);
  i := 1;
  while i <= k do
    if Result[i] = ' ' then
    begin
      Delete(Result, i, 1);
      k := k - 1;
    end
    else
      i := i + 1;
end;


//разделение строки
procedure ParseLineSimple(const Line: string; var Name, MarkMA, MarkAiG, MarkDiskr: string);
var
  A: array of string;
  i, n: integer;
begin
  Name := '';
  MarkMA := '';
  MarkAiG := '';
  MarkDiskr := '';

  A := Line.Split(' ');
  n := 0;
  for i := 0 to A.Length - 1 do
    if A[i] <> '' then
    begin
      case n of
        0: Name := A[i];
        1: MarkMA := A[i];
        2: MarkAiG := A[i];
        3: MarkDiskr := A[i];
      end;
      Inc(n);
      if n = 4 then
        Break;
    end;
end;


//создание или добавление
procedure MakeAndAddText;
var
  ch: char;
  Ok: boolean;
  TextName: string[12];
  Name: string[20];
  MarkMA: string[3];
  MarkAiG: string[3];
  MarkDiskr: string[3];
  StudentText: text;
begin
  ClrScr;
  WriteLn('Введите имя файла');
  ReadLn(TextName);

  Assign(StudentText, TextName);
  if System.IO.File.Exists(TextName) then
    Append(StudentText)
  else
    Rewrite(StudentText);

  Ok := True;
  while Ok do
  begin
    WriteLn('Введите фамилию');
    ReadLn(Name);

    WriteLn('Введите оценку по МатАнализу');
    ReadLn(MarkMA);

    WriteLn('Введите оценку по АиГ');
    ReadLn(MarkAiG);

    WriteLn('Введите оценку по ДискрМат');
    ReadLn(MarkDiskr);

    WriteLn(StudentText, Name, ' ', MarkMA, ' ', MarkAiG, ' ', MarkDiskr);

    WriteLn('Добавить еще? (n - выход)');
    ReadLn(ch);
    if ch in ['n', 'N'] then
    begin
      Ok := False;
      Close(StudentText);
    end
    else
      ClrScr;
  end;
end;


//просмотр файла
procedure ViewText;
var
  TextName: string[12];
  Line: string;
  Name, MarkMA, MarkAiG, MarkDiskr: string;
  StudentText: text;
begin
  ClrScr;
  WriteLn('Введите имя файла');
  ReadLn(TextName);

  Assign(StudentText, TextName);
  // {$I-}
  try
    Reset(StudentText);
  except
    begin
      WriteLn('Файл ', TextName, ' не найден');
      ReadLn;
      Exit;
    end;
  end;
  // {$I+}

  WriteLn('Фамилия              МА    АиГ   ДискрМат');
  WriteLn('------------------------------------------');

  while not Eof(StudentText) do
  begin
    ReadLn(StudentText, Line);
    ParseLineSimple(Line, Name, MarkMA, MarkAiG, MarkDiskr);
    if (Name <> '') and (MarkMA <> '') and (MarkAiG <> '') and (MarkDiskr <> '') then
      WriteLn(MyWrite(Name):20, MarkMA:6, MarkAiG:6, MarkDiskr:10);
  end;

  Close(StudentText);
  WriteLn;
  WriteLn('Нажмите Enter');
  ReadLn;
end;


//плохие ученики
procedure BadBoys(x: byte);
var
  TextName: string[12];
  Line: string;
  Name, MarkMA, MarkAiG, MarkDiskr: string;
  StudentText: text;
  IsBad: boolean;
  FoundAny: boolean;
begin
  ClrScr;
  WriteLn('Введите имя файла');
  ReadLn(TextName);

  Assign(StudentText, TextName);
  // {$I-}
  try
    Reset(StudentText);
  except
    begin
      WriteLn('Файл ', TextName, ' не найден');
      ReadLn;
      Exit;
    end;
  end;
  // {$I+}

  WriteLn('Фамилия              МА    АиГ   ДискрМат');
  WriteLn('------------------------------------------');

  FoundAny := False;
  while not Eof(StudentText) do
  begin
    ReadLn(StudentText, Line);
    ParseLineSimple(Line, Name, MarkMA, MarkAiG, MarkDiskr);
    if (Name = '') or (MarkMA = '') or (MarkAiG = '') or (MarkDiskr = '') then
      Continue;

    case x of
      1: IsBad := (MarkMA.Trim = '2');
      2: IsBad := (MarkAiG.Trim = '2');
      3: IsBad := (MarkDiskr.Trim = '2');
    else
      IsBad := (MarkMA.Trim = '2') or (MarkAiG.Trim = '2') or (MarkDiskr.Trim = '2');
    end;

    if IsBad then
    begin
      FoundAny := True;
      WriteLn(MyWrite(Name):20, MarkMA:6, MarkAiG:6, MarkDiskr:10);
    end;
  end;

  Close(StudentText);
  if not FoundAny then
    WriteLn('Двоечники не найдены.');
  WriteLn;
  WriteLn('Нажмите Enter');
  ReadLn;
end;

//ученики с двумя и более двойками
procedure BadBoysTwo;
var
  TextName: string[12];
  Line: string;
  Name, MarkMA, MarkAiG, MarkDiskr: string;
  StudentText: text;
  TwoCount: integer;
  FoundAny: boolean;
begin
  ClrScr;
  WriteLn('Введите имя файла');
  ReadLn(TextName);

  Assign(StudentText, TextName);
  try
    Reset(StudentText);
  except
    begin
      WriteLn('Файл ', TextName, ' не найден');
      ReadLn;
      Exit;
    end;
  end;

  WriteLn('Фамилия              МА    АиГ   ДискрМат');
  WriteLn('------------------------------------------');

  FoundAny := False;
  while not Eof(StudentText) do
  begin
    ReadLn(StudentText, Line);
    ParseLineSimple(Line, Name, MarkMA, MarkAiG, MarkDiskr);
    if (Name = '') or (MarkMA = '') or (MarkAiG = '') or (MarkDiskr = '') then
      Continue;

    TwoCount := 0;
    if MarkMA.Trim = '2' then Inc(TwoCount);
    if MarkAiG.Trim = '2' then Inc(TwoCount);
    if MarkDiskr.Trim = '2' then Inc(TwoCount);

    if TwoCount >= 2 then
    begin
      FoundAny := True;
      WriteLn(MyWrite(Name):20, MarkMA:6, MarkAiG:6, MarkDiskr:10);
    end;
  end;

  Close(StudentText);
  if not FoundAny then
    WriteLn('Студенты с двумя двойками не найдены.');
  WriteLn;
  WriteLn('Нажмите Enter');
  ReadLn;
end;

//менюшка
procedure DrawInterfaceStudentFile2;
var
  Choice: string;
  IsExit: boolean;
begin
  IsExit := False;
  repeat
    ClrScr;
    TextColor(White);
    WriteLn('=== Студенты файл 2===');
    WriteLn('1. Создание и добавление');
    WriteLn('2. Просмотр всех');
    WriteLn('3. Добавление');
    WriteLn('4. Двоечники по МА');
    WriteLn('5. Двоечники по АиГ');
    WriteLn('6. Двоечники по ДискрМат');
    WriteLn('7. Bad Boys (общ)');
    WriteLn('8. Две двойки и более');
    WriteLn('0. Выход');
    Write('Выбор пункта: ');
    ReadLn(Choice);

    case Choice of
      '1': MakeAndAddText;
      '2': ViewText;
      '3': MakeAndAddText;
      '4': BadBoys(1);
      '5': BadBoys(2);
      '6': BadBoys(3);
      '7': BadBoys(0);
      '8': BadBoysTwo;
      '0': IsExit := True;
    else
      begin
        WriteLn('Неверный пункт. Нажмите Enter...');
        ReadLn;
      end;
    end;
  until IsExit;
end;

end.
