unit pins;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dllform, StdCtrls, pinsedit, Ingeo_TLB;
const llkey='pins_LineLayer';
      plkey='pins_PinsLayer';
type
  TfPins = class(TM2AddonForm)
    Label1: TLabel;
    Label2: TLabel;
    eLineName: TEdit;
    Button1: TButton;
    Button2: TButton;
    ePinName: TEdit;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    editor:TPinsSelector;
    linelayer,pinlayer:string;
    procedure LoadParams;
    procedure SaveParams;
    { Private declarations }
  public

    { Public declarations }
  end;

var
  fPins: TfPins;

implementation
uses sellayer, addn;
{$R *.dfm}

procedure TfPins.Button1Click(Sender: TObject);
var f:TfSelectLayer;
begin
  f:=TfSelectLayer.Create(self);
  if f.ShowModal=mrOk then
  begin
    linelayer:=f.sellayer;
    eLineName.Text:=f.selname;
    editor.pinlar:=pinlayer;
    editor.linelar:=linelayer;
  end;
  f.Free;
end;

procedure TfPins.Button2Click(Sender: TObject);
var f:TfSelectLayer;
begin
  f:=TfSelectLayer.Create(self);
  if f.ShowModal=mrOk then
  begin
    pinlayer:=f.sellayer;
    ePinName.Text:=f.selname;
    editor.pinlar:=pinlayer;
    editor.linelar:=linelayer;
  end;
  f.Free;
end;

procedure TfPins.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveParams;
  gAddon.MapView.RemoveEditor(editor.IEditor);
  editor.Free;
  editor:=nil;
end;

procedure TfPins.FormShow(Sender: TObject);
begin
  editor:=TPinsSelector.Create(gAddon);
  LoadParams;
  editor.pinlar:=pinlayer;
  editor.linelar:=linelayer;
  gAddon.MapView.AddEditor(editor.IEditor);

end;

procedure TfPins.LoadParams;
begin
  linelayer:=gAddon2.UserProfile.Get(inupUser,'',llkey,'');
  pinlayer:=gAddon2.UserProfile.Get(inupUser,'',plkey,'');
  editor.pinlar:=pinlayer;
  editor.linelar:=linelayer;
  eLineName.Text:=GetLayerName(linelayer);
  ePinName.Text:=GetLayerName(pinlayer);

end;

procedure TfPins.SaveParams;
begin
  gAddon2.UserProfile.Put(inupUser,'',llkey,linelayer);
  gAddon2.UserProfile.Put(inupUser,'',plkey,pinlayer);
end;

end.
