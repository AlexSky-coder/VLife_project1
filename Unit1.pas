unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    Timer1: TTimer;
    PaintBox1: TPaintBox;
    N100001: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N17ms1: TMenuItem;
    N50ms1: TMenuItem;
    N250ms1: TMenuItem;
    N50ms2: TMenuItem;
    N1sek1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    SaveDialog1: TSaveDialog;
    N1mc1: TMenuItem;
    N8: TMenuItem;
    SaveDialog2: TSaveDialog;
    OpenDialog1: TOpenDialog;
    N9: TMenuItem;
    N10: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure N100001Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1Click(Sender: TObject);
    procedure N17ms1Click(Sender: TObject);
    procedure N50ms1Click(Sender: TObject);
    procedure N250ms1Click(Sender: TObject);
    procedure N50ms2Click(Sender: TObject);
    procedure N1sek1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure N1mc1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


//наборы команд
//	если спокойно0
//	если существо 1

//команды
//  0 ничего не делать или мутация
//	1 посмотреть еду
//	2 движение
//	3 поворот влево
//  4 поворот вправо

const
  max_kom=20;
  max_sit=1;




type
  tLife=class(TObject)
  c:array [0..max_sit,0..max_kom] of Integer; //команды, данные
  kom,sit:integer; //текущая команда, данные
  Life:integer;
  eng:real; //енергия
  gr:real; // направление
  x,y:real; //координаты
  color:tcolor;
  Procedure step(pitra:real; d:real; chygoi:tlife);
  end;


var
  Form1: TForm1;
  map:tbitmap;
  b:array of tLife;
  petri:real;
  cw,ch:integer;
  count_life:integer;
  step_z,count_z:integer;
  //time_simyl:tdatetime;

  //инфобот
  getMX,getMY,getBOT:integer;

implementation

{$R *.dfm}

function non(n:integer):string;
begin
//  0 ничего не делать или мутация
//	1 посмотреть еду
//	2 движение
//	3 поворот влево
//  4 поворот вправо
//  5 сожрать
//  6 размножаться
//  7 получить енергию
//  8 поделится с родствеником
if n=0 then Result:='Мут.';
if n=1 then Result:='1';
if n=2 then Result:='Шаг';
if n=3 then Result:='Пов. +';
if n=4 then Result:='Пов. -';
if n=5 then Result:='Сожр.';
if n=6 then Result:='Дел.';
if n=7 then Result:='ФС.';
if n=8 then Result:='ОРЕ';
end;

function tp(x,y,x1,y1:real):real;
begin
Result:=Sqrt(sqr(x1-x)+sqr(y1-y));
end;

function bot_look(a,n:tlife):real;  //дистанция
var dx,dy:real;
begin
dx:=a.x-n.x;
dy:=a.y-n.y;
Result:=Sqrt(Sqr(dx)+Sqr(dy));
end;



procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
map:=TBitmap.Create;
map.Width:=Width;
map.Height:=Height;
cw:=map.Width div 2;
ch:=map.Height div 2;
if cw>ch then petri:=ch-5 else petri:=cw-5;

SetLength(b,400);
for I := Low(b) to High(b) do
  begin
    b[i]:=Tlife.Create;
    b[i].gr:=Random(360)*(pi/180);
    repeat
    b[i].x:=random(map.Width);
    b[i].y:=Random(map.Height);
    until (tp(b[i].x,b[i].y,cw,ch)<petri-10);
    b[i].Life:=0;
    b[i].color:=clWhite;
    b[i].eng:=500.0;
  end;

//time_simyl:=Now;
getBOT:=0;
count_z:=1;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key='1' then b[getBOT].c[b[getBOT].sit,b[getBOT].kom]:=1;
if key='2' then b[getBOT].c[b[getBOT].sit,b[getBOT].kom]:=2;
if key='3' then b[getBOT].c[b[getBOT].sit,b[getBOT].kom]:=3;
if key='4' then b[getBOT].c[b[getBOT].sit,b[getBOT].kom]:=4;
if key='5' then b[getBOT].c[b[getBOT].sit,b[getBOT].kom]:=5;
if key='6' then b[getBOT].c[b[getBOT].sit,b[getBOT].kom]:=6;
if key='7' then b[getBOT].c[b[getBOT].sit,b[getBOT].kom]:=7;
if key='8' then b[getBOT].c[b[getBOT].sit,b[getBOT].kom]:=8;
if key='9' then b[getBOT].eng:=0;

end;

procedure TForm1.FormResize(Sender: TObject);
var i:integer;
begin
map.Width:=PaintBox1.Width;
map.Height:=PaintBox1.Height;
cw:=map.Width div 2;
ch:=map.Height div 2;
if cw>ch then petri:=ch*0.7 else petri:=cw*0.7;


for I := Low(b) to High(b) do
  begin
    repeat
    b[i].x:=random(map.Width);
    b[i].y:=Random(map.Height);
    until (tp(b[i].x,b[i].y,cw,ch)<petri-10);
  end;



end;

procedure TForm1.N100001Click(Sender: TObject);
begin
 count_z:=100;
end;

procedure TForm1.N10Click(Sender: TObject);
var n,i:integer; bb:boolean;    s:string;
begin
Timer1.Enabled:=False;
repeat
n:=0;
s:=vcl.Dialogs.InputBox('Введите новое количество ботов','Введите число > 0 ','400');
TryStrToInt(s,n);
if n>0 then bb:=true else bb:=False;
until bb=True;

  if bb then
    begin
    for I := Low(b) to High(b) do b[i].Destroy;
    setlength(b,n);
    for I := Low(b) to High(b) do b[i]:=tLife.Create;
    n2.Click;
  end;


Timer1.Enabled:=True;
end;

procedure TForm1.N17ms1Click(Sender: TObject);
begin
  Timer1.Interval:=15;
end;

procedure TForm1.N1mc1Click(Sender: TObject);
begin
Timer1.Interval:=1;
end;

procedure TForm1.N1sek1Click(Sender: TObject);
begin
Timer1.Interval:=1000;
end;

procedure TForm1.N250ms1Click(Sender: TObject);
begin
Timer1.Interval:=250;
end;

procedure TForm1.N2Click(Sender: TObject);
var i,x,y:integer;
begin
//сначала
Timer1.Enabled:=False;
sleep(50);
for I := Low(b) to High(b) do
  begin
    b[i].eng:=1000;
    for x := 0 to max_sit do
     for y := 0 to max_kom do b[i].c[x,y]:=0;
    b[i].color:=clWhite;
    b[i].kom:=0;
    b[i].sit:=0;
    b[i].gr:=Random(360)*(pi/180);
    b[i].Life:=0;
    repeat
    b[i].x:=random(map.Width);
    b[i].y:=Random(map.Height);
    until (tp(b[i].x,b[i].y,cw,ch)<=petri);
  end;
getBOT:=0;
Timer1.Enabled:=True;

//time_simyl:=Now;
end;

procedure TForm1.N50ms1Click(Sender: TObject);
begin
Timer1.Interval:=50;
end;

procedure TForm1.N50ms2Click(Sender: TObject);
begin
Timer1.Interval:=500;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
form1.Close;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
Timer1.Enabled:=False;
if SaveDialog1.Execute then
   begin

   if LowerCase(ExtractFileExt(SaveDialog1.FileName))<>'.bmp' then
     map.SaveToFile(SaveDialog1.FileName+'.bmp')
     else
     map.SaveToFile(SaveDialog1.FileName);
   end;
Timer1.Enabled:=True;
end;

procedure TForm1.N8Click(Sender: TObject);
var f:file of real;  i,x,y:integer; r:real;
begin
if SaveDialog2.Execute then begin
  AssignFile(f,savedialog2.FileName);
  Rewrite(f);
  r:=High(b);
  write(f,r);
  for I := Low(b) to High(b) do
    begin
      write(f,b[i].eng);
      for x := 0 to max_sit do
       for y := 0 to max_kom do begin
                                  r:=b[i].c[x,y];
                                  write(f,r);
                                end;
     r:=b[i].color;
     write(f,r);
     r:=b[i].kom;
     write(f,r);
     r:=b[i].sit;
     write(f,r);
     r:=b[i].gr;
     write(f,r);
     r:=b[i].Life;
     write(f,r);
     r:=b[i].x;
     write(f,r);
     r:=b[i].y;
     write(f,r);
    end;
    CloseFile(f);
end;
end;

procedure TForm1.N9Click(Sender: TObject);
//var f:file of real;  i,x,y:integer; r:real;
begin
{if SaveDialog2.Execute then begin
  AssignFile(f,savedialog2.FileName);
  Rewrite(f);
  r:=High(b);
  write(f,r);
  for I := Low(b) to High(b) do
    begin
      write(f,b[i].eng);
      for x := 0 to max_sit do
       for y := 0 to max_kom do begin
                                  r:=b[i].c[x,y];
                                  write(f,r);
                                end;
     r:=b[i].color;
     write(f,r);
     r:=b[i].kom;
     write(f,r);
     r:=b[i].sit;
     write(f,r);
     r:=b[i].g;
     write(f,r);
     r:=b[i].Life;
     write(f,r);
     r:=b[i].x;
     write(f,r);
     r:=b[i].y;
     write(f,r);
    end;
    CloseFile(f);
end;  }
end;

procedure TForm1.PaintBox1Click(Sender: TObject);
var j,n:integer;  dist,r:real;
begin
n:=0;
dist:=1000000000;
    for j := Low(b) to High(b) do  //ищем ближайшего бота
      if (b[j].eng>0) then
      begin
        r:=tp(b[j].x,b[j].y,getMX,getMY); //теорема пифагора
        if dist>r then
        begin
          dist:=r; //дистанция
          n:=j;    //номер ближайшего бота
        end;
      end;
getBOT:=n;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
getMX:=x;
getMY:=Y;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i,j,x,y:integer;
  r:real;
  dist:real; //дистанция к ближайшему боту
  n:integer; //ближайший бот

begin
n:=-1;
//чистим форму
map.Canvas.Brush.Color:=0;
map.Canvas.Pen.Color:=0;
map.Canvas.Rectangle(map.Canvas.ClipRect);

map.Canvas.Pen.Color:=clRed;
map.Canvas.Ellipse(cw-Trunc(petri),ch-Trunc(petri),cw+Trunc(petri),ch+Trunc(petri));

//расчет

count_life:=0;
for step_z := 1 to count_z do
for I := Low(b) to High(b) do if b[i].eng>0 then
  begin
  inc(count_life);

    dist:=10000000;
    for j := Low(b) to High(b) do  //ищем ближайшего бота
      if (i<>j)and(b[j].eng>0) then
      begin
        r:=bot_look(b[i],b[j]); //теорема пифагора
        if dist>r then
        begin
          dist:=r; //дистанция
          n:=j;    //номер ближайшего бота
        end;
      end;

   if (dist>13)  then begin
                    if b[i].sit<>0 then
                    begin
                      b[i].sit:=0;
                      b[i].kom:=0;
                    end;
                    end
                    else
                    if b[i].sit<>1 then
                    begin
                      b[i].sit:=1;
                      b[i].kom:=0;
                    end;

   b[i].step(petri,dist,b[n]);
  end;
count_z:=1;
if n>=0 then if b[getBOT].eng<=0 then getbot:=n;


  //рисуем ботов
for I := Low(b) to High(b) do
  if b[i].eng>0 then
  begin
   x:=Round(b[i].x);
   y:=Round(b[i].y);
   map.Canvas.Brush.Color:=b[i].color;
   map.Canvas.Pen.Color:=b[i].color;
   map.Canvas.Ellipse(x-5,y-5,x+5,y+5);
  end;




//инфа
  map.Canvas.Brush.Color:=0;
  map.Canvas.Font.Color:=clGreen;
  map.Canvas.TextOut(10,20,'Кол-во живых - '+inttostr(count_life));
//инфо одного бота
if getBOT>=0 then begin
                  map.Canvas.Pen.Color:=clRed;
                  x:=Round(b[getBOT].x);
                  y:=Round(b[getBOT].y);
                  map.Canvas.MoveTo(x+10,y+10); map.Canvas.LineTo(x-10,y-10);
                  map.Canvas.MoveTo(x-10,y+10); map.Canvas.LineTo(x+10,y-10);
                 //map.Canvas.Brush.Color:=0;
                  map.Canvas.TextOut(10,40,'Bot #'+inttostr(getBOT));
                  map.Canvas.TextOut(10,55,'Енергия     - '+FloatToStr(b[getBOT].eng));
                  map.Canvas.TextOut(10,70,'Цикл жизни  - '+inttostr(b[getBOT].Life));
                      for x := 0 to max_sit do
                      for y := 0 to max_kom do
                     begin
                      if (x=b[getBOT].sit)and(y=b[getBOT].kom) then
                      map.Canvas.Brush.Color:=clWhite else map.Canvas.Brush.Color:=0;
                      map.Canvas.TextOut(10+(x*50),85+(y*15),inttostr(b[getBOT].c[x,y]));
                     end;
                  end;

  //рисуем на экране
  PaintBox1.Canvas.Draw(0,0,map);
  //если все умерли начинаем сначала
  if count_life=0 then begin Timer1.Enabled:=False; n2.Click; end;

end;


//копируем бота
procedure copybot(bot: tlife);
var xx,yy,i,n:integer;
begin
  n:=-1;
//ищем последнего бота
  for I := Low(b) to High(b) do if b[i].eng<=0 then n:=i;
//если бота нашли
  if n>=0 then begin
    bot.eng:=Trunc(bot.eng) div 2;
    b[n].Life:=0;
    b[n].eng:=bot.eng;
    b[n].sit:=0;
    b[n].kom:=0;
    b[n].color:= bot.color;
    b[n].x:=bot.x+(random(3)-1)*10;
    b[n].y:=bot.y+(random(3)-1)*10;
    //переписываем команды
    for xx := 0 to max_sit do
      for yy := 0 to max_kom do b[n].c[xx,yy]:=bot.c[xx,yy];
  end;
end;
//---------------------------------------------------------------------------------
{ tLife }
procedure tLife.step(pitra:real; d:real; chygoi:tlife);
var i:integer; tp1:real;
begin
//команды
//  0 ничего не делать или мутация
//	1 посмотреть еду
//	2 движение
//	3 поворот влево
//  4 поворот вправо
//  5 сожрать
//  6 размножаться
//  7 получить енергию
//  8 поделится с родствеником

tp1:=tp(x,y,cw,ch);

if (c[sit,kom]=0)or((Random(1000)>998)and(Life>1000)) then
            begin
            Randomize;
            i:=Random(9)+1;
            if i<>c[sit,kom] then begin
                                  c[sit,kom]:=i;
                                  color:=Random(clWhite);
                                  end;
            //kom:=0;
            end;

if (c[sit,kom]=1)and(Random(100)>95) then
                        if tp1<pitra then c[sit,kom]:=7 else c[sit,kom]:=8;


if c[sit,kom]=2 then if eng>1 then
            begin
             x:=x+Cos(gr)*0.5;
             y:=y+sin(gr)*0.5;
             eng:=eng-0.2;
            end;

if c[sit,kom]=3 then gr:=gr-(pi/180*15);
if c[sit,kom]=4 then gr:=gr+(pi/180*15);

if c[sit,kom]=5 then if (d<11)and(color<>chygoi.color) then begin
                     eng:=eng+Trunc(chygoi.eng);
                     chygoi.eng:=0;
                     end;

if c[sit,kom]=6 then if (eng>=30) then copybot(Self);

if c[sit,kom]=7 then if ((tp1<=pitra)and(d>=10)) then eng:=eng+5;

if c[sit,kom]=8 then if ((d<=10)and(color=chygoi.color)) then
                     begin
                     eng:=eng-1;
                     if(tp1>pitra)then chygoi.eng:=chygoi.eng+8 else
                     chygoi.eng:=chygoi.eng+2;
                     end;

if c[sit,kom]=9 then c[sit,kom]:=Random(2000)+100;


if c[sit,kom]>=100 then if life>c[sit,kom] then eng:=0;


if d<5 then eng:=eng-1;
eng:=eng-1;
Life:=Life+1;
if life>2000 then eng:=Trunc(eng*0.8);
kom:=kom+1;
if kom<0 then kom:=0;
if kom>max_kom then kom:=0;
end;


end.
