unit HVmenu;

interface

uses Crt;

type
  PtrVertic = ^StackVertic;
  
  StackVertic = record
    Number: Integer;
    Name: String[10];
    Grade: Integer; 
    Next: PtrVertic;
  end;

  PtrHoriz = ^StackHoriz;
  
  StackHoriz = record
    Number: Integer;
    Group: String[6];
    Head: PtrVertic;
    Next: PtrHoriz;
  end;

procedure MakeMenuHoriz(var Horiz: PtrHoriz); //создание группы
procedure MakeMenuVertic(var Vertic: PtrVertic); //создание студентов
procedure ChoiceMenuHoriz(Horiz: PtrHoriz); // показать группы
procedure PutMenuVertic(Vertic: PtrVertic); //показать студента *
procedure AddNewGroup(var Horiz: PtrHoriz); //добавить группу
procedure AddNewStudent(Horiz: PtrHoriz); //добавить студента
procedure AddGradesForGroup(Horiz: PtrHoriz); //добавить оценку
procedure ShowExcellent(Horiz: PtrHoriz); //показать отличников
procedure DrawInterfacel2; //интерфейс

implementation

//инициализация горизонтали
procedure MakeMenuHoriz(var Horiz: PtrHoriz);
var
  Top, Prev: PtrHoriz;
  GroupValue: String[6];
  Ok: Boolean;
  k: Integer;
begin
  Ok := True;
  Horiz := Nil;
  k := 0;
  Prev := Nil;
  while Ok do
  begin
    WriteLn('Введите название группы (или n для выхода):');
    ReadLn(GroupValue);
    if (GroupValue = 'n') or (GroupValue = 'N') then Ok := False
    else
    begin
      Inc(k);
      New(Top);
      Top^.Next := Nil;
      Top^.Number := k;
      Top^.Group := GroupValue;
      MakeMenuVertic(Top^.Head);
      if Horiz = Nil then Horiz := Top
      else Prev^.Next := Top;
      Prev := Top;
    end;
  end;
end;

//инициализация вертикали
procedure MakeMenuVertic(var Vertic: PtrVertic);
var
  Top, Prev: PtrVertic;
  Ok: Boolean;
  NameValue: String[10];
  k: Integer;
begin
  Ok := True;
  Vertic := Nil;
  k := 0;
  Prev := Nil;
  while Ok do
  begin
    WriteLn('  Введите фамилию (или n для выхода):');
    ReadLn(NameValue);
    if (NameValue = 'n') or (NameValue = 'N') then Ok := False
    else
    begin
      Inc(k);
      New(Top);
      Top^.Next := Nil;
      Top^.Number := k;
      Top^.Name := NameValue;
      Top^.Grade := 0; 
      if Vertic = Nil then Vertic := Top
      else Prev^.Next := Top;
      Prev := Top;
    end;
  end;
end;

{Добавление Группы}
procedure AddNewGroup(var Horiz: PtrHoriz);
var
  NewGroup, Temp: PtrHoriz;
  GroupValue: String[6];
  k: Integer;
begin
  ClrScr;
  WriteLn('--- Добавление новой группы ---');
  Write('Введите название группы: ');
  ReadLn(GroupValue);
  
  New(NewGroup);
  NewGroup^.Group := GroupValue;
  NewGroup^.Next := Nil;
  NewGroup^.Head := Nil;
  
  { Определяем номер для новой группы }
  if Horiz = Nil then
  begin
    NewGroup^.Number := 1;
    Horiz := NewGroup;
  end
  else
  begin
    Temp := Horiz;
    k := 1;
    while Temp^.Next <> Nil do
    begin
      Temp := Temp^.Next;
      Inc(k);
    end;
    NewGroup^.Number := Temp^.Number + 1;
    Temp^.Next := NewGroup;
  end;
  
  WriteLn('Группа ', GroupValue, ' добавлена. Добавьте студентов:');
  MakeMenuVertic(NewGroup^.Head);
end;

//Добавление Студента
procedure AddNewStudent(Horiz: PtrHoriz);
var
  H: PtrHoriz;
  V, NewStudent: PtrVertic;
  GroupNum: Integer;
  NameValue: String[10];
begin
  ClrScr;
  WriteLn('--- Добавление студента ---');
  H := Horiz;
  while H <> Nil do
  begin
    WriteLn(H^.Number, '. ', H^.Group);
    H := H^.Next;
  end;
  Write('Выберите номер группы: ');
  ReadLn(GroupNum);
  
  H := Horiz;
  while (H <> Nil) and (H^.Number <> GroupNum) do
    H := H^.Next;
    
  if H <> Nil then
  begin
    Write('Введите фамилию нового студента: ');
    ReadLn(NameValue);
    
    New(NewStudent);
    NewStudent^.Name := NameValue;
    NewStudent^.Grade := 0;
    NewStudent^.Next := Nil;
    
//Определение номера для нового студента
    if H^.Head = Nil then
    begin
      NewStudent^.Number := 1;
      H^.Head := NewStudent;
    end
    else
    begin
      V := H^.Head;
      while V^.Next <> Nil do
        V := V^.Next;
      NewStudent^.Number := V^.Number + 1;
      V^.Next := NewStudent;
    end;
    WriteLn('Студент ', NameValue, ' добавлен.');
  end
  else
    WriteLn('Группа не найдена.');
  ReadLn;
end;

//Показать все группы горизонтально, студентов вертикально под группой
procedure ChoiceMenuHoriz(Horiz: PtrHoriz);
var
  H: PtrHoriz;
  V: PtrVertic;
  Col, Row, ColWidth, MaxStudents, StudCount: Integer;
begin
  ClrScr;
  ColWidth := 22; { ширина столбца для каждой группы }

  { Считаем максимальное количество студентов среди всех групп }
  MaxStudents := 0;
  H := Horiz;
  while H <> Nil do
  begin
    StudCount := 0;
    V := H^.Head;
    while V <> Nil do
    begin
      Inc(StudCount);
      V := V^.Next;
    end;
    if StudCount > MaxStudents then MaxStudents := StudCount;
    H := H^.Next;
  end;

  { Выводим названия групп по горизонтали на строке 1 }
  H := Horiz;
  Col := 0;
  while H <> Nil do
  begin
    GoToXY(Col * ColWidth + 1, 1);
    Write(H^.Number, '.Группа ', H^.Group);
    Inc(Col);
    H := H^.Next;
  end;

  { Разделитель }
  GoToXY(1, 2);
  H := Horiz;
  Col := 0;
  while H <> Nil do
  begin
    GoToXY(Col * ColWidth + 1, 2);
    Write('--------------------');
    Inc(Col);
    H := H^.Next;
  end;

  { Выводим студентов вертикально под своей группой }
  H := Horiz;
  Col := 0;
  while H <> Nil do
  begin
    V := H^.Head;
    Row := 3;
    while V <> Nil do
    begin
      GoToXY(Col * ColWidth + 1, Row);
      Write('  ', H^.Number, '.', V^.Number, ' ', V^.Name);
      Inc(Row);
      V := V^.Next;
    end;
    Inc(Col);
    H := H^.Next;
  end;

  GoToXY(1, MaxStudents + 4);
  Write('Нажмите Enter...');
  ReadLn;
end;

//выбор студентов
procedure PutMenuVertic(Vertic: PtrVertic);
var
  Top: PtrVertic;
  PozX, PozY: Integer;
begin
  Top := Vertic;
  PozY := 5;
  PozX := 20;
  GoToXY(PozX, PozY - 1);
  WriteLn('Студенты:');
  while Top <> Nil do
  begin
    Inc(PozY);
    GoToXY(PozX, PozY);
    WriteLn(Top^.Number, '. ', Top^.Name);
    Top := Top^.Next;
  end;
end;


//добавление оценки
procedure AddGradesForGroup(Horiz: PtrHoriz);
var
  H: PtrHoriz;
  V: PtrVertic;
  GroupNum, StudentNum: Integer;
begin
  ClrScr;
  WriteLn('--- Ввод оценок ---');
  H := Horiz;
  while H <> Nil do
  begin
    WriteLn(H^.Number, '. ', H^.Group);
    H := H^.Next;
  end;
  Write('Выберите номер группы: ');
  ReadLn(GroupNum);

  H := Horiz;
  while (H <> Nil) and (H^.Number <> GroupNum) do
    H := H^.Next;

  if H <> Nil then
  begin
    PutMenuVertic(H^.Head);
    WriteLn;
    Write('Введите номер студента: ');
    ReadLn(StudentNum);

    V := H^.Head;
    while (V <> Nil) and (V^.Number <> StudentNum) do
      V := V^.Next;
    
    if V <> Nil then
    begin
      Write('Введите оценку для ', V^.Name, ': ');
      ReadLn(V^.Grade);
    end
    else
      WriteLn('Студент не найден.');
  end
  else
    WriteLn('Группа не найдена.');
  ReadLn;
end;


//показать отличников
procedure ShowExcellent(Horiz: PtrHoriz);
var
  H: PtrHoriz;
  V: PtrVertic;
begin
  ClrScr;
  WriteLn('--- Отличники (Оценка 5) ---');
  H := Horiz;
  while H <> Nil do
  begin
    V := H^.Head;
    while V <> Nil do
    begin
      if V^.Grade = 5 then
        WriteLn(V^.Name, ' (Группа ', H^.Group, ')');
      V := V^.Next;
    end;
    H := H^.Next;
  end;
  WriteLn('Нажмите Enter...');
  ReadLn;
end;
procedure DrawInterfacel2;
var
  RootMenu: PtrHoriz;
  Choice: Integer;
  ExitProgram: Boolean;
  InputStr: String;
  Code: Integer;
begin
  RootMenu := Nil;
  ExitProgram := False;
  
  repeat
    ClrScr;
    TextColor(White);
    WriteLn('=== ГЛАВНОЕ МЕНЮ ===');
    WriteLn('1. Создать новую структуру');
    WriteLn('2. Ввести оценку студенту');
    WriteLn('3. Показать отличников');
    WriteLn('4. Посмотреть список группы');
    WriteLn('5. Добавить группу');
    WriteLn('6. Добавить студента в группу');
    WriteLn('0. Выход');
    WriteLn('--------------------');
    Write('Выберите пункт (0-6): ');
    
    ReadLn(InputStr);
    Val(InputStr, Choice, Code);
    if Code <> 0 then Choice := -1;

    case Choice of
      1: begin
           MakeMenuHoriz(RootMenu);
           WriteLn('Структура создана. Нажмите Enter...');
           ReadLn;
         end;
      2: begin
           if RootMenu <> Nil then AddGradesForGroup(RootMenu)
           else begin WriteLn('Нет данных.'); ReadLn; end;
         end;
      3: begin
           if RootMenu <> Nil then ShowExcellent(RootMenu)
           else begin WriteLn('Нет данных.'); ReadLn; end;
         end;
      4: begin
           if RootMenu <> Nil then ChoiceMenuHoriz(RootMenu)
           else begin WriteLn('Нет данных.'); ReadLn; end;
         end;
      5: begin
           AddNewGroup(RootMenu);
         end;
      6: begin
           if RootMenu <> Nil then AddNewStudent(RootMenu)
           else begin WriteLn('Нет данных. Сначала добавьте группу.'); ReadLn; end;
         end;
      0: ExitProgram := True;
    else
      begin
        WriteLn('Неверный пункт. Нажмите Enter...');
        ReadLn;
      end;
    end;
    
  until ExitProgram;
end;
end.