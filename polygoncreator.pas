unit polygoncreator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dllform, ComCtrls, StdCtrls, upointselector, Ingeo_TLB;

type
  TfPolygonCreator = class(TM2AddonForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    eR: TEdit;
    cbRType: TComboBox;
    Label2: TLabel;
    ePCount: TEdit;
    UpDown1: TUpDown;
    eAngle: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    eX: TEdit;
    Label6: TLabel;
    eY: TEdit;
    Button3: TButton;
    Label7: TLabel;
    cbStyle: TComboBox;
    procedure cbStyleChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure ePCountExit(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    editor:TUPointSelector;
    procedure SaveParams;
    procedure LoadParams;
    procedure RefreshEditor;
    procedure CreateObject;
    procedure LoadStyleList;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPolygonCreator: TfPolygonCreator;

implementation
uses addn;
{$R *.dfm}

procedure TfPolygonCreator.Button1Click(Sender: TObject);
begin
  CreateObject;
end;

procedure TfPolygonCreator.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfPolygonCreator.Button3Click(Sender: TObject);
begin
  Hide;
  editor.pointselecting:=True;
end;

procedure TfPolygonCreator.cbStyleChange(Sender: TObject);
begin
  editor.styleid:=gAddon2.ActiveProjectView.ActiveLayerView.Layer.Styles.Item[cbStyle.ItemIndex].ID;
end;

procedure TfPolygonCreator.CreateObject;
begin
  editor.CreateObject;
  Close;
end;

procedure TfPolygonCreator.ePCountExit(Sender: TObject);
begin
  RefreshEditor;
end;

procedure TfPolygonCreator.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  gAddon.MapView.RemoveEditor(editor.IEditor);
  SaveParams;
end;

procedure TfPolygonCreator.FormCreate(Sender: TObject);
begin
  editor:=TUPointSelector.Create(gAddon,self);
  gAddon.MapView.AddEditor(editor.IEditor);
  editor.pointselecting:=False;
  editor.eX:=eX;
  editor.eY:=eY;
  LoadStyleList;
  editor.styleid:=gAddon2.ActiveProjectView.ActiveLayerView.Layer.Styles.Item[cbStyle.ItemIndex].ID;
//  TryStr
  LoadParams;
end;

procedure TfPolygonCreator.LoadParams;
var i:integer;
begin
//  gAddon2.UserProfile.Put(inupUser,'','POLYCREATE_PCOUNT',IntToStr(UpDown1));
  TryStrToInt(gAddon2.UserProfile.Get(inupUser,'','POLYCREATE_PCOUNT','3'), i);
  UpDown1.Position:=i;
  eR.Text:=gAddon2.UserProfile.Get(inupUser,'','POLYCREATE_ER','5');
  TryStrToInt(gAddon2.UserProfile.Get(inupUser,'','POLYCREATE_RTYPE','0'), i);
  cbRType.ItemIndex:=i;
  eAngle.Text:=gAddon2.UserProfile.Get(inupUser,'','POLYCREATE_ANGLE','0');
  eX.Text:=gAddon2.UserProfile.Get(inupUser,'','POLYCREATE_EX','0');
  eY.Text:=gAddon2.UserProfile.Get(inupUser,'','POLYCREATE_EY','0');

end;

procedure TfPolygonCreator.LoadStyleList;
var layer:IIngeoLayer;
  i: Integer;
begin
  layer:=gAddon2.ActiveProjectView.ActiveLayerView.Layer;
  cbStyle.Items.Clear;
  for i := 0 to layer.Styles.Count - 1 do
  begin
    cbStyle.Items.Add(layer.Styles.Item[i].Name);
  end;
  cbStyle.ItemIndex:=
  StrToInt( gAddon2.UserProfile.Get(inupUser,gAddon2.ActiveProjectView.ActiveLayerView.Layer.ID,'POLYCREATE_SI','0'));
end;

procedure TfPolygonCreator.RefreshEditor;
begin
   editor.pcount:=UpDown1.Position;
   editor.rtype:=cbRType.ItemIndex;
   TryStrToFloat(eAngle.Text, editor.angle);
   editor.angle:=editor.angle/180*pi;
   TryStrToFloat(eR.Text,editor.er);
   gAddon.MapView.Invalidate;
end;

procedure TfPolygonCreator.SaveParams;
begin
  gAddon2.UserProfile.Put(inupUser,'','POLYCREATE_PCOUNT',IntToStr(UpDown1.Position));
  gAddon2.UserProfile.Put(inupUser,'','POLYCREATE_ER',eR.Text);
  gAddon2.UserProfile.Put(inupUser,'','POLYCREATE_RTYPE', INttoStr(cbRType.ItemIndex));
  gAddon2.UserProfile.Put(inupUser,'','POLYCREATE_ANGLE',eAngle.Text);
  gAddon2.UserProfile.Put(inupUser,'','POLYCREATE_EX',eX.Text);
  gAddon2.UserProfile.Put(inupUser,'','POLYCREATE_EY',eY.Text);

  gAddon2.UserProfile.Put(inupUser,gAddon2.ActiveProjectView.ActiveLayerView.Layer.ID,'POLYCREATE_SI',IntToStr(cbStyle.ItemIndex));

end;

procedure TfPolygonCreator.UpDown1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  RefreshEditor;
end;

end.
