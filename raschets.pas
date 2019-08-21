unit raschets;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ComCtrls, ExtCtrls, M2Addon, Variants;

type
  TRec=record
    code:integer;
    value:real;
    prim:string;
    name:string;
  end;


  TfRaschet = class
  private
    rArr:array [1..100] of TRec;
    prArr:array [1..100] of TRec;
    cc,pcc,sotri:integer;
    ntime:integer;
    errorslist:TStringList;
    carr:array [1..10000,1..2] of integer;
    ccount:integer;
    tpv:array [1..100,1..100] of TRec;
    tpvc:array [1..100] of integer;

    function GetNExt(var s:string):string;
    function GetInteger(var s:string):integer;
    function Calc2(var s:string):real;
    function Calc2a(var s:string):real;
    function Calc3(var s:string):real;
    function Calc4(var s:string):real;
    function GetFloat(var s:string):real;
    function GetSemValue(var s:string):real;
    function GetFunctionValue(var s:string):real;
    function GetPCount(obj:TM2ID):integer;
    function GetObjData(obj:TM2ID;field:string):string;
    function CalcIF(p1,p2,p3:real):real;
    constructor Create;
    { Private declarations }
  public
    rorder:array [1..100] of integer;
    ordercount:integer;
    rdate,du:string;
    function Calc1(var s:string):real;
    { Public declarations }
  end;

var
  fRaschet: TfRaschet;

implementation
uses math ,frm, addn, Ingeo_TLB;




function TfRaschet.Calc1(var s: string): real;
var a,b:real;
    op:char;
begin
  GetNext(s);
  a:=Calc2(s);
  REsult:=a;
  if Length(s)=0 then exit;
  op:=s[1];
  while op in ['+','-'] do
  begin
    Delete(s,1,1);
    GetNext(s);
    b:=Calc2(s);
    case op of
    '+':Result:=Result+b;
    '-':Result:=Result-b;
    end;
    if Length(s)=0 then break;
    op:=s[1];
  end;
end;

function TfRaschet.Calc2(var s: string): real;
var a,b:real;
    op:char;
begin
  GetNext(s);
  a:=Calc2a(s);
  REsult:=a;
  if Length(s)=0 then exit;
  op:=s[1];
  while op in ['*','/'] do
  begin
    Delete(s,1,1);
    GetNext(s);
    b:=Calc2a(s);
    case op of
    '*':Result:=Result*b;
    '/':Result:=Result/b;
    end;
    if Length(s)=0 then break;
    op:=s[1];
  end;
end;

function TfRaschet.Calc3(var s: string): real;
begin
  if s[1]='(' then
  begin
    Delete(s,1,1);
    Result:=Calc1(s);
    Delete(s,1,1);
  end
  else
    Result:=Calc4(s);
end;

function TfRaschet.Calc4(var s: string): real;
begin
  case s[1] of
  '0'..'9':
       begin
         Result:=GetFloat(s);
       end;
  '{': begin
         Result:=GetSemValue(s);
       end;
  'À'..'ß','à'..'ÿ','A'..'Z','a'..'z':
       begin
         Result:=GetFunctionValue(s);
       end;
  end;
end;

function TfRaschet.GetNExt(var s: string): string;
begin
  if Length(s)=0 then exit;
//  Delete(s,1,1);
  while s[1] in [' '] do
    Delete(s,1,1);
  Result:=s;
end;

function TfRaschet.GetInteger(var s: string): integer;
var ts:string;
begin
  ts:='';
  while s[1] in ['0'..'9'] do
  begin
    ts:=ts+s[1];
    Delete(s,1,1);
    if Length(s)=0 then break;
  end;
  Result:=StrToInt(ts);
end;



function TfRaschet.GetFloat(var s: string): real;
var ts:string;
begin
  ts:='';
  while s[1] in ['0'..'9'] do
  begin
    ts:=ts+s[1];
    Delete(s,1,1);
    if Length(s)=0 then break;
  end;
  if Length(s)>0 then
  if s[1]=',' then
  begin
    ts:=ts+',';
    Delete(s,1,1);
    while s[1] in ['0'..'9'] do
    begin
      ts:=ts+s[1];
      Delete(s,1,1);
      if Length(s)=0 then break;
    end;
  end;
  Result:=StrTofloat(ts);
end;



function TfRaschet.GetFunctionValue(var s: string): real;
var fn:string;
    p1,p2,p3,p4:real;
begin
  try
  fn:='';
  while (Length(s)>0) and  (s[1]<>'(') do
  begin
    fn:=fn+s[1];
    Delete(s,1,1);
  end;
  if s[1]<>'(' then errorslist.Add('Íåîæèäàííûé êîíåö ñòğîêè');
  fn:=AnsiUpperCase(Trim(fn));
  Delete(s,1,1);
  GetNExt(s);
  if s[1]<>')' then
  begin
    p1:=Calc1(s);
  end;
  GetNExt(s);
  if s[1]<>')' then
  begin
    Delete(s,1,1);
    p2:=Calc1(s);
  end;
  GetNExt(s);
  if s[1]<>')' then
  begin
    Delete(s,1,1);
    p3:=Calc1(s);
  end;
  GetNExt(s);
  if s[1]<>')' then
  begin
    Delete(s,1,1);
    p4:=Calc1(s);
  end;

  if fn='ABS' then Result:=abs(p1);
  if fn='ARCCOS' then Result:=ArcCos(p1);
  if fn='ARCCOSH' then Result:=ArcCosh(p1);
  if fn='ARCSIN' then Result:=ArcSin(p1);
  if fn='ARCSINH' then Result:=ArcSinh(p1);
  if fn='ARCTAN' then Result:=ArcTan(p1);
  if fn='ARCTAN2' then Result:=ArcTan2(p1,p2);
  if fn='ARCTANH' then Result:=ArcTanh(p1);
  if fn='COS' then Result:=COS(p1);
  if fn='COSH' then Result:=COSH(p1);
  if fn='EXP' then Result:=exp(p1);
  if fn='LN' then Result:=Ln(p1);
  if fn='LOG' then Result:=LogN(p1,p2);
  if fn='LOG10' then Result:=Log10(p1);
  if fn='LOG2' then Result:=Log2(p1);
  if fn='SIN' then Result:=sin(p1);
  if fn='SINH' then Result:=sinh(p1);
  if fn='TAN' then Result:=tan(p1);
  if fn='TANH' then Result:=tanh(p1);
  if fn='ÃĞÀÄÓÑÛ' then Result:=p1/pi*180;
  if fn='ÄĞÎÁ×ÀÑÒÜ' then Result:=Frac(p1);
  if fn='ÇÍÀÊ' then Result:=SIGN(p1);
  if fn='ÊÎĞÅÍÜ' then Result:=SQRT(p1);
  if fn='ÎÊĞÓÃË' then Result:=RoundTo(p1,Round(p2));
  if fn='ÎÊĞÓÃËÂÂÅĞÕ' then Result:=Trunc(p1)+1;
  if fn='ÎÊĞÓÃËÂÍÈÇ' then Result:=Trunc(p1);
  if fn='ÏÈ' then Result:=pi;
  if fn='ĞÀÄÈÀÍÛ' then Result:=p1/180*pi;
  if fn='ÑÒÅÏÅÍÜ' then Result:=power(p1,p2);
  if fn='ÖÅË×ÀÑÒÜ' then Result:=Int(p1);
  if fn='ÅÑËÈ' then Result:=CalcIF(p1,p2,p3);
  except
    on e:Exception do errorslist.Add('Îøèáêà âû÷èñëåíèÿ ôóíêöèè '+fn+' '+e.Message);
  end;
  Delete(s,1,1);
end;

function TfRaschet.GetSemValue(var s: string): real;
var ts:string;
    res:Extended;
begin
  ts:=Copy(s,2,Pos('}',s)-2);

  Delete(s,1,Pos('}',s));
//    res:=StrToFloat(Trim(GetObjData(MainForm.gobj,ts)));
//      on e:Exception do ShowMessage('Îøèáêà  '+field);
    res:=0;
  Result:=res;
end;

constructor TfRaschet.Create;
begin
  inherited;
  errorslist:=TStringList.Create;
end;

function TfRaschet.GetPCount(obj: TM2ID): integer;
var iss:IIngeoShapes;
    i:integer;
begin
  REsult:=0;
  gAddon2.ActiveDb.MapObjects.GetObject(obj).Shapes;
  for i:=0 to iss.Count-1 do
  begin
    if iss.Item[i].Contour.Square>0 then
    begin
      Result:=iss.Item[i].Contour.Count;
      exit;
    end;
  end;
end;

function TfRaschet.GetObjData(obj: TM2ID; field: string): string;
var t,f,s:string;
    tc,i:integer;
    v:olevariant;
begin
  REsult:='';
  t:=Copy(field,1,Pos('.',field)-1);
  f:=Copy(field,Pos('.',field)+1,200);
  tc:=gAddon2.ActiveDb.MapObjects.GetObject(obj).SemData.GetRecCount(t);
//  gAddon2.ActiveDb.LayerFromID(gAddon2.ActiveDb.MapObjects.GetObject(obj).LayerID).SemTables.Item[i].LinkType

  if Pos('.',f)>0 then
  begin
    s:=Copy(f,Pos('.',f)+1,200);
    f:=Copy(f,1,Pos('.',f)-1);
    i:=StrToInt(s);
    if (i+1)>=tc then exit;
    try
    v:=VarToStr(gAddon2.ActiveDb.MapObjects.GetObject(obj).SemData.GetValue(t,f,i));
    except
      on e:Exception do ShowMessage('Îøèáêà èçâëå÷åíèÿ 2 {'+t+'.'+f+'}');
    end;
    if VarIsNull(v) then exit;
    s:=v;
    Result:=s;
    exit;
  end;

  s:='';
  for i:=0 to tc-1 do
  begin
    if i>0 then s:=s+',';
    try
    v:='';
    v:= VarToStr(gAddon2.ActiveDb.MapObjects.GetObject(obj).SemData.GetValue(t,f,i));
    except
      on e:Exception do ShowMessage('Îøèáêà èçâëå÷åíèÿ 1 {'+t+'.'+f+'}');
    end;
    if VarIsNull(v) then continue;
    s:=s+v;
  end;
  Result:=s;
end;

function TfRaschet.CalcIF(p1, p2, p3: real): real;
begin
  if p1=0 then Result:=p2 else Result:=p3;
end;

function TfRaschet.Calc2a(var s: string): real;
var a,b:real;
    op,op2:char;
    res:boolean;
begin
  GetNext(s);
  a:=Calc3(s);
  REsult:=a;
  if Length(s)=0 then exit;
  op:=s[1];
  op2:=' ';
  while op in ['>','<','='] do
  begin
    Delete(s,1,1);
    GetNext(s);
    if s[1] in ['='] then op2:=s[1];
    Delete(s,1,1);
    GetNext(s);

    b:=Calc3(s);
    case op of
    '>': case op2 of
         '=':Res:=Result>=b;
         ' ':Res:=Result>b;
         end;
    '<':case op2 of
         '=':Res:=Result<=b;
         ' ':Res:=Result<b;
         end;
    '=':Res:=Result=b;
    end;
    REsult:=IfThen(res,0,1);
    if Length(s)=0 then break;
    op:=s[1];
  end;
end;

end.
