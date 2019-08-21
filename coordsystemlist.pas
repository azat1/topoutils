unit coordsystemlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, xmlintf;

type
  TfCoordSystemList = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure UpdateList;
    { Private declarations }
  public
    node:IXMLNode;
    { Public declarations }
  end;

var
  fCoordSystemList: TfCoordSystemList;

implementation
uses fcoordeditor;
{$R *.dfm}

procedure TfCoordSystemList.Button1Click(Sender: TObject);
var f:TfCoordEdit;
    nd:IXMLNode;
begin
  f:=TfCoordEdit.Create(self);
  if f.ShowModal=mrOk then
  begin
    nd:=node.AddChild('projection');
    nd.SetAttributeNS('Name','',f.eName.Text);
    nd.SetAttributeNS('CM','',f.eCM.Text);
    nd.SetAttributeNS('FX','',f.eFNorth.Text);
    nd.SetAttributeNS('FY','',f.eFEast.Text);
    nd.SetAttributeNS('Datum','',f.cbDatumType.ItemIndex);
    nd.SetAttributeNS('Scale','',f.eScale.Text);
    UpdateList;
  end;
end;

procedure TfCoordSystemList.Button2Click(Sender: TObject);
var nd:IXMLNode;
    f:TfCoordEdit;
begin
  if ListBox1.ItemIndex<>-1 then
  begin
    nd:=node.ChildNodes.Get(ListBox1.ItemIndex);
    f:=TfCoordEdit.Create(self);
    f.eName.Text:=nd.GetAttributeNS('Name','');
    f.eCM.Text:=nd.GetAttributeNS('CM','');
    f.eFNorth.Text:=nd.GetAttributeNS('FX','');
    f.eFEast.Text:=nd.GetAttributeNS('FY','');
    f.cbDatumType.ItemIndex:=nd.GetAttributeNS('Datum','');
    f.eScale.Text:=nd.GetAttributeNS('Scale','');
    if f.ShowModal=mrOk then
    begin
      nd.SetAttributeNS('Name','',f.eName.Text);
      nd.SetAttributeNS('CM','',f.eCM.Text);
      nd.SetAttributeNS('FX','',f.eFNorth.Text);
      nd.SetAttributeNS('FY','',f.eFEast.Text);
      nd.SetAttributeNS('Datum','',f.cbDatumType.ItemIndex);
      nd.SetAttributeNS('Scale','',f.eScale.text);
      UpdateList;
    end;
  end;
end;

procedure TfCoordSystemList.Button3Click(Sender: TObject);
begin
  if ListBox1.ItemIndex<>-1 then
  begin
    if MessageDlg('Действительно удалить проекцию!',Dialogs.mtConfirmation,[mbYes,mbNo],0)=IDYES then
    begin
      node.ChildNodes.Delete(ListBox1.ItemIndex);
      UpdateList;
    end;
    
  end;
end;

procedure TfCoordSystemList.FormShow(Sender: TObject);
begin
  UpdateList;
end;

procedure TfCoordSystemList.UpdateList;
var
  i: Integer;
  nd:IXMLNode;
begin
  ListBox1.Items.Clear;
  for i := 0 to node.ChildNodes.Count - 1 do
  begin
    nd:=node.ChildNodes.Get(i);
    ListBox1.Items.Add(nd.GetAttributeNS('Name',''));
  end;

end;

end.
