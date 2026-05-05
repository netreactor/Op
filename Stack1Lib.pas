unit Stack1Lib;

interface

uses crt; 

type
  Ptr = ^Stak;
  Stak = record
    Inf: integer;
    Next: Ptr;
  end;

// Добавляем параметр Head во все процедуры, которые работают со стеком
procedure MakeStack(var Head: Ptr);
procedure AddStack(var Head: Ptr);
procedure ViewStack(Head: Ptr);
procedure ReverseStack(var Head: Ptr);
procedure MergeStacks(var Head1: Ptr; var Head2: Ptr);
procedure DrawInterfacel1(var Head: Ptr); 

implementation

procedure AddStack(var Head: Ptr);
var
  s: string;
  valCode, num: integer;
  NewNode: Ptr;
begin
  while true do
  begin
    write('Введите число (999 - выход): ');
    readln(s);
    Val(s, num, valCode);
    if (valCode = 0) and (num = 999) then exit;
    if valCode <> 0 then
    begin
      TextColor(LightRed);
      writeln('Ошибка: введите целое число или 999');
      TextColor(LightGreen);
    end
    else
    begin
      new(NewNode);
      NewNode^.Inf := num;
      NewNode^.Next := Head;
      Head := NewNode;
    end;
  end;
end;

procedure MakeStack(var Head: Ptr);
begin
  Head := nil;
  writeln('--- Создание нового стека ---');
  AddStack(Head);
end;

procedure ViewStack(Head: Ptr);
var
  Temp: Ptr;
begin
  if Head = nil then 
  begin
    TextColor(LightRed);
    writeln('[ Стек пуст ]');
    TextColor(White);
    exit;
  end;
  
  TextColor(Yellow);
  write(' [TOP] -> ');
  Temp := Head;
  while Temp <> nil do
  begin
    write('| ', Temp^.Inf, ' | -> ');
    Temp := Temp^.Next;
  end;
  writeln('Nil');
  TextColor(White);
end;

procedure ReverseStack(var Head: Ptr);
var
  Prev, Curr, NextNode: Ptr;
begin
  Prev := nil;
  Curr := Head;
  while Curr <> nil do
  begin
    NextNode := Curr^.Next;
    Curr^.Next := Prev;
    Prev := Curr;
    Curr := NextNode;
  end;
  Head := Prev;
end;

procedure MergeStacks(var Head1: Ptr; var Head2: Ptr);
var
  Temp: Ptr;
begin
  if Head2 = nil then exit;
  
  if Head1 = nil then
    Head1 := Head2
  else
  begin
    Temp := Head1;
    while Temp^.Next <> nil do
      Temp := Temp^.Next;
    
    Temp^.Next := Head2;
  end;
  Head2 := nil; 
end;

procedure DrawInterfacel1(var Head: Ptr);
var
  yPos: integer;
  choice: string;
  isExit: boolean;
  S2: Ptr;
begin
  isExit := false;
  repeat
    ClrScr; 
    TextColor(Yellow);
    writeln('==================== ТЕКУЩИЙ СТЕК ====================');
    ViewStack(Head); 
    TextColor(Yellow);
    writeln('======================================================');
    
    yPos := WhereY;
    GotoXY(1, yPos + 1); 
    TextColor(Cyan);
    writeln('--- МЕНЮ УПРАВЛЕНИЯ ---');
    TextColor(White);
    writeln('1. Создать новый стек (очистить текущий)');
    writeln('2. Добавить элементы в начало');
    writeln('3. Перевернуть стек (Reverse)');
    writeln('4. Создать второй стек и приклеить в конец первого');
    writeln('0. Выход');
    TextColor(LightBlue);
    write('Выберите действие: '); 
    TextColor(White);
    readln(choice);
    
    case choice of
      '1': MakeStack(Head);
      '2': AddStack(Head);
      '3': ReverseStack(Head);
      '4': begin
             writeln('--- Ввод данных для ВТОРОГО стека ---');
             S2 := nil;
             MakeStack(S2);
             writeln('--- Выполнение слияния ---');
             MergeStacks(Head, S2);
             writeln('Слияние завершено!');
             delay(1000);
           end;
      '0': isExit := true;
    else
      begin
        TextColor(LightRed);
        writeln('Неверный пункт меню.');
        TextColor(White);
        delay(1000);
      end;
    end;
  until isExit;
end;

end.