unit about;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    LVer: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation
 uses registry, dialogs,frm;

{$R *.DFM}

procedure TAboutBox.FormCreate(Sender: TObject);
var mh:THandle;
    ver,z:pchar;
    vs:integer;
    verin:^TVSFixedFileInfo;
    zz:pointer;
    w,w1:Integer;
    td:cardinal;
begin
  GetMem(z,300);
  mh:=GetModuleHandle('KADASTR.DLL');
  GetModuleFileName(mh,z,300);
  LVer.Caption:=LVer.Caption+z;
  vs:=GetFileVersionInfoSize(z,td);
  GetMem(ver,vs);
  GetFileVersionInfo(z,td,vs,ver);
  VerQueryValue(ver,'\',zz,td);
  verin:=zz;
  w:=verin^.dwFileVersionMS;
  w1:=verin^.dwFileVersionLS;
  LVer.Caption:='Build '+IntToStr(w shr 16)+
  '.'+IntToStr(w and $0000FFFF)+'.'+IntToStr(w1 shr 16)+
  '.'+IntToStr(w1 and $0000FFFF);

  FreeMem(ver,vs);
  FreeMem(z,300);
end;

procedure TAboutBox.Button1Click(Sender: TObject);
var s:string;
    r:Tregistry;
    i:integer;
begin
  //dddddd
  s:=InputBox('¬ведите код','¬ведите код','');
  begin
    for i:=1 to Length(s) do
    begin
      s[i]:=Chr(Ord(s[i])+10);
    end;
    r:=TRegistry.Create;
    r.OpenKey('Software\AzSoft\Keys',True);
    r.WriteString('KADASTR',s);
    r.Free;
  end;
end;

end.

