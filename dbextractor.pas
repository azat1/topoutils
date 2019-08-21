unit dbextractor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl,Ingeo_TLB, DB, DBTables, dataextractor;

type
  TfDBExtractor = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    Label2: TLabel;
    Button2: TButton;
    Button3: TButton;
    Memo1: TMemo;
    Button4: TButton;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    app:IIngeoApplication;
    datex:TDBExtractor;

    { Public declarations }
  end;

var
  fDBExtractor: TfDBExtractor;

implementation
{$R *.dfm}

procedure TfDBExtractor.Button1Click(Sender: TObject);
var dir:string;
begin
  if SelectDirectory('Выберите папку с БД','',dir) then
  begin
    Edit1.Text:=dir;
  end;


end;

procedure TfDBExtractor.Button2Click(Sender: TObject);
var dir:string;
begin
  if SelectDirectory('Выберите папку семантики БД','',dir) then
  begin
    Edit2.Text:=dir;
  end;


end;

procedure TfDBExtractor.Button3Click(Sender: TObject);
//var datex:TDBExtractor;
begin
  datex:=TDBExtractor.Create(Edit1.Text,Edit2.Text);
  datex.ExtractData();
  Memo1.SetTextBuf(datex.res.Memory);
end;

procedure TfDBExtractor.Button4Click(Sender: TObject);
begin
  datex.app:=app;
  datex.progresslabel:=Label3;
  datex.CreateObjects();
end;

end.
