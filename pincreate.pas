unit pincreate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Ingeo_TLB;

type
  TfPinCreate = class(TForm)
    Label1: TLabel;
    cbStyle: TComboBox;
    Label2: TLabel;
    eCount: TEdit;
    Label3: TLabel;
    eDistance: TEdit;
    cbMakeVector: TCheckBox;
    Button1: TButton;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure cbStyleChange(Sender: TObject);
    procedure eDistanceChange(Sender: TObject);
    procedure eCountChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LoadStyles;
  public
    pinlayer:string;
    linelength:double;
    autodist:boolean;
    pcount:integer;
    pdist:double;
    { Public declarations }
  end;

var
  fPinCreate: TfPinCreate;
  lastindex:integer;

implementation
uses addn;
{$R *.dfm}

procedure TfPinCreate.Button1Click(Sender: TObject);
begin
  if cbStyle.ItemIndex=-1 then
  begin
    ShowMessage('Не выбран стиль!');
    ModalResult:=mrNone;
    exit;
  end;
  if not TryStrToInt(eCount.Text,pcount) then
  begin
    ShowMessage('Неправильно введено количество!');
    ModalResult:=mrNone;
    exit;
  end;
  if not TryStrToFloat(eDistance.Text,pdist) then
  begin
    ShowMessage('Неправильно введена дистанция!');
    ModalResult:=mrNone;
    exit;
  end;

end;

procedure TfPinCreate.cbStyleChange(Sender: TObject);
begin
  lastindex:=cbStyle.ItemIndex;
end;

procedure TfPinCreate.eCountChange(Sender: TObject);
begin
  if ActiveControl<>eCount then
    exit;
  if TryStrToInt(eCount.Text,pcount) then
  begin
    eDistance.Text:=Format('%.3f',[linelength/(pcount+1)]);
    autodist:=True;
  end;
end;

procedure TfPinCreate.eDistanceChange(Sender: TObject);
begin
  if ActiveControl<>eDistance then
    exit;
  if TryStrToFloat(eDistance.Text,pdist) then
  begin
    eCount.Text:=Format('%d',[Round(linelength/pdist)-1]);
    autodist:=False;
  end;

end;

procedure TfPinCreate.FormShow(Sender: TObject);
begin
  LoadStyles;
  Label4.Caption:=Format('Длина линии = %.3f',[linelength]);
  if lastindex<cbStyle.Items.Count then
    cbStyle.ItemIndex:=lastindex;
end;

procedure TfPinCreate.LoadStyles;
var lar:IIngeoLayer;
  i: Integer;
begin
  lar:=gAddon2.ActiveDb.LayerFromID(pinlayer);
  for i := 0 to lar.Styles.Count - 1 do
  begin
    cbStyle.Items.Add(lar.Styles.Item[i].Name);
  end;

end;
initialization
  lastindex:=-1;
end.
