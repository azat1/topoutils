unit cpreport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfCpReport = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCpReport: TfCpReport;

implementation

{$R *.dfm}

procedure TfCpReport.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfCpReport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

end.
