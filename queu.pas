unit queu;

interface

uses Crt, Stack1Lib;

type
  PtrQ = ^QueuRec;
  QueuRec = record
    Int: integer;
    Next: PtrQ;
  end;

  PtrM = ^Mnogo;
  Mnogo = record
    Coeff: real;
    Deg: integer;
    Next: PtrM;
  end;

{ Очередь }
procedure MakeQueu(var Left, Right: PtrQ);
procedure AddQueu(var Left, Right: PtrQ);
procedure ViewQueue(Left: PtrQ);

{ Множество }
procedure MakeMnogo(var Head: PtrM);      { создание }
procedure AddMnogo(var H1: PtrM; H2: PtrM); { сложение }
procedure MultMnogo(var H1: PtrM; H2: PtrM); { умножение }
procedure JoinMnogo(var H1: PtrM; H2: PtrM); { объединение }

{ Слияние двух очередей, первый в начале }
procedure MergeQueues(var Left1, Right1: PtrQ; var Left2, Right2: PtrQ);

{ Преобразования: стек <-> очередь }
procedure StackToQueue(StackHead: Ptr; var QLeft, QRight: PtrQ);
procedure QueueToStack(QLeft, QRight: PtrQ; var StackHead: Ptr);

{ Интерфейс меню }
procedure DrawInterfaceQueu(var QLeft, QRight: PtrQ);

implementation

//создать очередь
procedure MakeQueu(var Left, Right: PtrQ);
var
  OK: boolean;
  Value: integer;
  Top: PtrQ;
begin
  OK := True;
  Left := nil;
  Right := nil;
  Write('Введите число: ');
  ReadLn(Value);
  if Value = 999 then
  begin
    OK := False;
    exit;
  end;
  New(Top);
  Top^.Int := Value;
  Top^.Next := nil;
  Left := Top;
  Right := Top;
  while OK do
  begin
    Write('Введите число: ');
    ReadLn(Value);
    if Value = 999 then
    begin
      OK := False;
      Right^.Next := nil;
    end
    else
    begin
      New(Top);
      Right^.Next := Top;
      Top^.Next := nil;
      Top^.Int := Value;
      Right := Top;
    end;
  end;
end;

//добавить эл-нт в очередь
procedure AddQueu(var Left, Right: PtrQ);
var
  OK: boolean;
  Value: integer;
  Top: PtrQ;
begin
  OK := True;
  while OK do
  begin
    WriteLn('Введите число');
    ReadLn(Value);
    if Value = 999 then
      OK := False
    else
    begin
      New(Top);
      if Right <> nil then
        Right^.Next := Top;
      Top^.Next := nil;
      Top^.Int := Value;
      Right := Top;
      if Left = nil then Left := Top;
    end;
  end;
end;

//просмотр очередей
procedure ViewQueue(Left: PtrQ);
var
  Top: PtrQ;
begin
  if Left = nil then
  begin
    WriteLn('[ Очередь пуста ]');
    exit;
  end;
  Top := Left;
  while Top <> nil do
  begin
    WriteLn(Top^.Int:4);
    Top := Top^.Next;
  end;
end;

//слияне очередей
procedure MergeQueues(var Left1, Right1: PtrQ; var Left2, Right2: PtrQ);
begin
  if Left2 = nil then exit;
  if Left1 = nil then
  begin
    Left1 := Left2;
    Right1 := Right2;
  end
  else
  begin
    Right2^.Next := Left1;
    Left1 := Left2;
  end;
  Left2 := nil;
  Right2 := nil;
end;

//стэк -> очередь
procedure StackToQueue(StackHead: Ptr; var QLeft, QRight: PtrQ);
var
  Temp: Ptr;
  NewNode: PtrQ;
begin
  QLeft := nil;
  QRight := nil;
  Temp := StackHead;
  while Temp <> nil do
  begin
    New(NewNode);
    NewNode^.Int := Temp^.Inf;
    NewNode^.Next := nil;
    if QLeft = nil then
    begin
      QLeft := NewNode;
      QRight := NewNode;
    end
    else
    begin
      QRight^.Next := NewNode;
      QRight := NewNode;
    end;
    Temp := Temp^.Next;
  end;
end;

//очередь -> стэк
procedure QueueToStack(QLeft, QRight: PtrQ; var StackHead: Ptr);
var
  Temp: PtrQ;
  NewNode: Ptr;
begin
  StackHead := nil;
  Temp := QLeft;
  while Temp <> nil do
  begin
    New(NewNode);
    NewNode^.Inf := Temp^.Int;
    NewNode^.Next := StackHead;
    StackHead := NewNode;
    Temp := Temp^.Next;
  end;
end;


//создание множества
procedure MakeMnogo(var Head: PtrM);
var
  CoeffVal: real;
  DegVal: integer;
  Top, Prev: PtrM;
  OK: boolean;
begin
  Head := nil;
  OK := true;
  Prev := nil;
  while OK do
  begin
    Write('Коэффициент (999 для выхода): ');
    ReadLn(CoeffVal);
    if Abs(CoeffVal - 999) < 0.001 then
      OK := false
    else
    begin
      Write('Степень: ');
      ReadLn(DegVal);
      New(Top);
      Top^.Coeff := CoeffVal;
      Top^.Deg := DegVal;
      Top^.Next := nil;
      if Head = nil then Head := Top
      else Prev^.Next := Top;
      Prev := Top;
    end;
  end;
end;

//сложение множества
procedure AddMnogo(var H1: PtrM; H2: PtrM);
var
  T1, T2: PtrM;
  NewNode: PtrM;
  Prev: PtrM;
begin
  T2 := H2;
  while T2 <> nil do
  begin
    T1 := H1;
    while (T1 <> nil) and (T1^.Deg <> T2^.Deg) do
      T1 := T1^.Next;
    if T1 <> nil then
      T1^.Coeff := T1^.Coeff + T2^.Coeff
    else
    begin
      New(NewNode);
      NewNode^.Coeff := T2^.Coeff;
      NewNode^.Deg := T2^.Deg;
      NewNode^.Next := nil;
      if H1 = nil then H1 := NewNode
      else
      begin
        Prev := H1;
        while Prev^.Next <> nil do Prev := Prev^.Next;
        Prev^.Next := NewNode;
      end;
    end;
    T2 := T2^.Next;
  end;
end;

//умножение множества
procedure MultMnogo(var H1: PtrM; H2: PtrM);
var
  T1, T2: PtrM;
  ResHead, ResTail, NewNode: PtrM;
begin
  if (H1 = nil) or (H2 = nil) then
  begin
    H1 := nil;
    exit;
  end;
  ResHead := nil;
  ResTail := nil;
  T1 := H1;
  while T1 <> nil do
  begin
    T2 := H2;
    while T2 <> nil do
    begin
      New(NewNode);
      NewNode^.Coeff := T1^.Coeff * T2^.Coeff;
      NewNode^.Deg := T1^.Deg + T2^.Deg;
      NewNode^.Next := nil;
      if ResHead = nil then
      begin
        ResHead := NewNode;
        ResTail := NewNode;
      end
      else
      begin
        ResTail^.Next := NewNode;
        ResTail := NewNode;
      end;
      T2 := T2^.Next;
    end;
    T1 := T1^.Next;
  end;
  H1 := ResHead;
end;

//объединение множества
procedure JoinMnogo(var H1: PtrM; H2: PtrM);
var
  T2: PtrM;
  T1, Prev: PtrM;
  NewNode: PtrM;
begin
  T2 := H2;
  while T2 <> nil do
  begin
    T1 := H1;
    while (T1 <> nil) and (T1^.Deg <> T2^.Deg) do
      T1 := T1^.Next;
    if T1 = nil then
    begin
      New(NewNode);
      NewNode^.Coeff := T2^.Coeff;
      NewNode^.Deg := T2^.Deg;
      NewNode^.Next := nil;
      if H1 = nil then H1 := NewNode
      else
      begin
        Prev := H1;
        while Prev^.Next <> nil do Prev := Prev^.Next;
        Prev^.Next := NewNode;
      end;
    end;
    T2 := T2^.Next;
  end;
end;

//посмотреть множество
procedure ViewMnogo(Head: PtrM);
var
  T: PtrM;
begin
  T := Head;
  while T <> nil do
  begin
    WriteLn('  ', T^.Coeff:6:2, ' * x^', T^.Deg);
    T := T^.Next;
  end;
end;


//интерфейс
procedure DrawInterfaceQueu(var QLeft, QRight: PtrQ);
var
  choice: string;
  S1: Ptr;
  Q2Left, Q2Right: PtrQ;
  M1, M2: PtrM;
begin
  repeat
    ClrScr;
    TextColor(Yellow);
    WriteLn('==================== ОЧЕРЕДЬ ====================');
    ViewQueue(QLeft);
    TextColor(Yellow);
    WriteLn('==================================================');
    TextColor(Cyan);
    WriteLn('--- МЕНЮ ОЧЕРЕДИ ---');
    TextColor(White);
    WriteLn('1. Создать очередь (999 - выход)');
    WriteLn('2. Добавить в очередь');
    WriteLn('3. Слияние двух очередей');
    WriteLn('4. Стек -> Очередь');
    WriteLn('5. Очередь -> Стек');
    WriteLn('6. Множество: Make (создание)');
    WriteLn('7. Множество: Add (сложение)');
    WriteLn('8. Множество: Mult (умножение)');
    WriteLn('9. Множество: Join (объединение)');
    WriteLn('0. Выход');
    TextColor(LightBlue);
    Write('Выберите действие: ');
    TextColor(White);
    ReadLn(choice);

    case choice of
      '1': MakeQueu(QLeft, QRight);
      '2': AddQueu(QLeft, QRight);
      '3': begin
             WriteLn('--- Ввод второй очереди ---');
             Q2Left := nil;
             Q2Right := nil;
             MakeQueu(Q2Left, Q2Right);
             MergeQueues(QLeft, QRight, Q2Left, Q2Right);
             WriteLn('Слияние завершено.');
             ReadLn;
           end;
      '4': begin
             WriteLn('Введите стек (999 - выход):');
             S1 := nil;
             AddStack(S1);
             StackToQueue(S1, QLeft, QRight);
             WriteLn('Очередь создана из стека.');
             ReadLn;
           end;
      '5': begin
             S1 := nil;
             QueueToStack(QLeft, QRight, S1);
             WriteLn('Стек создан из очереди:');
             ViewStack(S1);
             ReadLn;
           end;
      '6': begin
             M1 := nil;
             MakeMnogo(M1);
             WriteLn('Множество создано:');
             ViewMnogo(M1);
             ReadLn;
           end;
      '7','8','9': begin
             WriteLn('Создайте два множества для операции.');
             M1 := nil;
             M2 := nil;
             WriteLn('Множество 1:');
             MakeMnogo(M1);
             WriteLn('Множество 2:');
             MakeMnogo(M2);
             if choice = '7' then AddMnogo(M1, M2)
             else if choice = '8' then MultMnogo(M1, M2)
             else JoinMnogo(M1, M2);
             WriteLn('Результат:');
             ViewMnogo(M1);
             ReadLn;
           end;
      '0': exit;
    else
      begin
        TextColor(LightRed);
        WriteLn('Неверный пункт.');
        TextColor(White);
        ReadLn;
      end;
    end;
  until false;
end;

end.
