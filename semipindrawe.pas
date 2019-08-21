unit semipindrawe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dllform, semipineditor;

type
  TfSemiPinDrawer = class(TM2AddonForm)
    Label1: TLabel;
    cbSelStyle: TComboBox;
    Label2: TLabel;
    eCommLayerName: TEdit;
    Button1: TButton;
    Label3: TLabel;
    Edit1: TEdit;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure cbSelStyleChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadStyles;
    procedure Save;
    procedure Load;
    function GetPinStyle:string;

  public
    editor:TSemiPinPointSelector;
    commlayer,pinlayer:string;
    stls:TStringList;
    { Public declarations }
  end;

var
  fSemiPinDrawer: TfSemiPinDrawer;

implementation
uses addn, Ingeo_TLB, SELLAYER;
{$R *.dfm}

{ TfSemiPinDrawer }

procedure TfSemiPinDrawer.Button1Click(Sender: TObject);
var f:TfSelectLayer;
begin
  f:=TfSelectLayer.Create(self);
  f.sellayer:=commlayer;
  if f.ShowModal=mrok then
  begin
    commlayer:=f.sellayer;
    eCommLayerName.Text:=GetLayerName(commlayer);
    editor.commlayer:=commlayer;
  end;
  f.Free;
end;

procedure TfSemiPinDrawer.Button2Click(Sender: TObject);
var f:TfSelectLayer;
begin
  f:=TfSelectLayer.Create(self);
  f.sellayer:=pinlayer;
  if f.ShowModal=mrok then
  begin
    pinlayer:=f.sellayer;
    LoadStyles;
    Edit1.Text:=GetLayerName(pinlayer);
//    editor.commlayer:=commlayer;
  end;
  f.Free;
end;

procedure TfSemiPinDrawer.cbSelStyleChange(Sender: TObject);
begin
  editor.pinstyle:=GetPinStyle;
end;

procedure TfSemiPinDrawer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Save;
  gAddon.MapView.RemoveEditor(editor.IEditor);
  editor.Free;
end;

procedure TfSemiPinDrawer.FormCreate(Sender: TObject);
begin
  LoadStyles;
  Load;
  editor:=TSemiPinPointSelector.Create(gAddon,nil);
  editor.commlayer:=commlayer;
  editor.pinstyle:=GetPinStyle;
  gAddon.MapView.AddEditor(editor.IEditor);

end;

function TfSemiPinDrawer.GetPinStyle: string;
begin
  try
  Result:=stls[cbSelStyle.ItemIndex];
  except
  REsult:='';

  end;
end;
procedure TfSemiPinDrawer.Load;
begin
  commlayer:=gAddon2.UserProfile.Get(inupUser,'','spd_commlayer','');
  pinlayer:=gAddon2.UserProfile.Get(inupUser,'','spd_pinlayer','');
  LoadStyles;
  try
    cbSelStyle.ItemIndex:=
     cbSelStyle.Items.IndexOf(gAddon2.UserProfile.Get(inupUser,'','spd_selstyle',''));
  except

  end;
  eCommLayerName.Text:=GetLayerName(commlayer);
    Edit1.Text:=GetLayerName(pinlayer);
end;

procedure TfSemiPinDrawer.LoadStyles;
var lar:IIngeoLayer;
  i: Integer;
begin

   stls:=TStringList.Create;
   cbSelStyle.Items.Clear;
   try
     lar:=gAddon2.ActiveDb.LayerFromID(pinlayer);//.SelectedLayerView.Layer;
   except
     exit;
   end;
//   if lar. then

   for i := 0 to lar.Styles.Count - 1 do
   begin
     cbSelStyle.Items.Add(lar.Styles.Item[i].Name);
     stls.Add(lar.Styles.Item[i].ID);
   end;
end;

procedure TfSemiPinDrawer.Save;
begin
  gAddon2.UserProfile.Put(inupUser,'','spd_commlayer',commlayer);
  gAddon2.UserProfile.Put(inupUser,'','spd_pinlayer',pinlayer);
  gAddon2.UserProfile.Put(inupUser,'','spd_selstyle',cbSelStyle.Text);
end;

end.
