unit StudentFileLib;

interface

uses crt, System.IO;

type
  Student = record
    Name: string[10];
    Mark: string[3];
  end;

procedure MakeFile;
procedure ViewFile;
procedure AddFile;
procedure DelMark2;
procedure DeleteFile;
procedure DrawInterfaceStudentFile;

implementation

//создать файл
procedure MakeFile;
var
  Cmd: string[10];
  Ok: boolean;
  FileName: string[12];
  StudentFile: file of Student;
  NowStudent: Student;
begin
  Ok := True;
  ClrScr;
  WriteLn('Введите имя файла:');
  ReadLn(FileName);

  Assign(StudentFile, FileName);
  Rewrite(StudentFile);

  with NowStudent do
  while Ok do
  begin
    GotoXY(30, 12);
    Write('                              ');
    GotoXY(30, 13);
    Write('                              ');
    GotoXY(30, 14);
    Write('                              ');
    GotoXY(30, 15);
    Write('                              ');
    GotoXY(30, 16);
    Write('                              ');
    GotoXY(30, 17);
    Write('                              ');

    GotoXY(30, 12);
    WriteLn('Введите фамилию студента');
    GotoXY(30, 13);
    ReadLn(Name);

    GotoXY(30, 14);
    WriteLn('Введите оценку');
    GotoXY(30, 15);
    ReadLn(Mark);

    Write(StudentFile, NowStudent);

    GotoXY(30, 16);
    WriteLn('Добавить еще? (для выхода 999)');
    GotoXY(30, 17);
    ReadLn(Cmd);

    if Cmd = '999' then
    begin
      Ok := False;
      Close(StudentFile);
    end;
  end;
end;

//просмотреть файл
procedure ViewFile;
var
  k: integer;
  FileName: string[12];
  StudentFile: file of Student;
  NowStudent: Student;
begin
  ClrScr;
  k := 3;
  WriteLn('Введите имя файла:');
  ReadLn(FileName);

  Assign(StudentFile, FileName);
  Reset(StudentFile);

  with NowStudent do
  while not Eof(StudentFile) do
  begin
    k := k + 1;
    Read(StudentFile, NowStudent);
    GotoXY(1, k);
    Write(Name);
    GotoXY(11, k);
    Write(Mark);
  end;

  Close(StudentFile);
  GotoXY(1, k + 2);
  WriteLn('Нажмите Enter');
  ReadLn;
end;

//Добавить записи в существующий файл
procedure AddFile;
var
  Cmd: string[10];
  Ok: boolean;
  FileName: string[12];
  StudentFile: file of Student;
  NowStudent: Student;
begin
  ClrScr;
  WriteLn('Введите имя существующего файла:');
  ReadLn(FileName);

  if not System.IO.File.Exists(FileName) then
  begin
    WriteLn('Файл не найден.');
    WriteLn('Нажмите Enter');
    ReadLn;
    exit;
  end;

  Assign(StudentFile, FileName);
  Reset(StudentFile);
  Seek(StudentFile, FileSize(StudentFile));

  Ok := True;
  with NowStudent do
  while Ok do
  begin
    GotoXY(30, 12);
    Write('                              ');
    GotoXY(30, 13);
    Write('                              ');
    GotoXY(30, 14);
    Write('                              ');
    GotoXY(30, 15);
    Write('                              ');
    GotoXY(30, 16);
    Write('                              ');
    GotoXY(30, 17);
    Write('                              ');

    GotoXY(30, 12);
    WriteLn('Введите фамилию студента');
    GotoXY(30, 13);
    ReadLn(Name);

    GotoXY(30, 14);
    WriteLn('Введите оценку');
    GotoXY(30, 15);
    ReadLn(Mark);

    Write(StudentFile, NowStudent);

    GotoXY(30, 16);
    WriteLn('Добавить еще? (для выхода 999)');
    GotoXY(30, 17);
    ReadLn(Cmd);

    if Cmd = '999' then
    begin
      Ok := False;
      Close(StudentFile);
    end;
  end;
end;

//Удалить записи с оценкой два
procedure DelMark2;
var
  NewName, FileName: string[12];
  NewFile, StudentFile: file of Student;
  NowStudent: Student;
begin
  ClrScr;
  WriteLn('Введите имя файла:');
  ReadLn(FileName);

  Assign(StudentFile, FileName);
  Reset(StudentFile);

  NewName := 'aaaa.tmp';
  Assign(NewFile, NewName);
  Rewrite(NewFile);

  while not Eof(StudentFile) do
  begin
    Read(StudentFile, NowStudent);
    if NowStudent.Mark <> '2' then
      Write(NewFile, NowStudent);
  end;

  Close(StudentFile);
  Erase(StudentFile);

  Close(NewFile);
  Rename(NewFile, FileName);

  WriteLn('Записи с оценкой 2 удалены.');
  WriteLn('Нажмите Enter');
  ReadLn;
end;

//Удалить файл
procedure DeleteFile;
var
  FileName: string;
begin
  ClrScr;
  WriteLn('Введите имя файла для удаления:');
  ReadLn(FileName);

  if not System.IO.File.Exists(FileName) then
  begin
    WriteLn('Файл не найден или недоступен.');
    WriteLn('Нажмите Enter');
    ReadLn;
    exit;
  end;

  try
    System.IO.File.Delete(FileName);
    WriteLn('Файл удален.');
  except
    WriteLn('Не удалось удалить файл.');
  end;

  WriteLn('Нажмите Enter');
  ReadLn;
end;


//менюшка
procedure DrawInterfaceStudentFile;
var
  Choice: string;
  IsExit: boolean;
begin
  IsExit := False;
  repeat
    ClrScr;
    TextColor(White);
    WriteLn('=== Студент файл ===');
    WriteLn('1. Создать файл');
    WriteLn('2. Просмотр файла');
    WriteLn('3. Добавить записи в существующий файл');
    WriteLn('4. Удалить записи с оценкой 2');
    WriteLn('5. Удалить файл');
    WriteLn('0. Выход');
    Write('Выбор пункта: ');
    ReadLn(Choice);

    case Choice of
      '1': MakeFile;
      '2': ViewFile;
      '3': AddFile;
      '4': DelMark2;
      '5': DeleteFile;
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

