unit linear;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  M2Addon,DllForm, Buttons, StdCtrls, ExtCtrls;

type
  TfLinear = class(TM2AddonForm)
    Label1: TLabel;
    eX1: TEdit;
    eY1: TEdit;
    eX2: TEdit;
    eY2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    eL1: TEdit;
    eL2: TEdit;
    Button1: TButton;
    Label10: TLabel;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLinear: TfLinear;

implementation
uses medit, addn;
{$R *.DFM}






procedure TfLinear.Button1Click(Sender: TObject);
begin
  Close;
  gAddon.MapView.RemoveEditor(PointSelector.IEditor);
end;

procedure TfLinear.FormCreate(Sender: TObject);
begin
  	if not Assigned(PointSelector) then begin
		PointSelector := TPointSelector.Create(gAddon);
		try
			gAddon.MapView.AddEditor(PointSelector.IEditor);
		finally
			PointSelector.IEditor._Release;
		end;
	end;
end;


procedure TfLinear.FormPaint(Sender: TObject);
var ci,cj,i,j:integer;
begin
  ci:=Width div Image2.Picture.Bitmap.Width;
  cj:=Height div Image2.Picture.Bitmap.Height;
  for i:=0 to ci do
    for j:=0 to cj do
    begin
      Canvas.Draw(i*Image2.Picture.Bitmap.Width,
                  j*Image2.Picture.Bitmap.Height,Image2.Picture.Bitmap);
    end;

end;

end.
