unit layoutfindreplace;

interface
uses Classes,SysUtils, Ingeo_TLB, InScripting_TLB;

type
  TLayoutMassOps=class
    public
      app:IIngeoApplication;
      constructor Create(app:IIngeoApplication);
      procedure FindReplace(filelist:TStrings;find,replace:string);
      procedure ReplaceInText(fig:IInPictureFigure;find,replace:string);
      procedure ReplaceInGrid(fig:IInPictureFigure;find,replace:string);
      procedure Print(filelist:TStrings);


  end;

implementation

{ TLayoutMassOps }

constructor TLayoutMassOps.Create(app: IIngeoApplication);
begin
  self.app:=app;
end;

procedure TLayoutMassOps.FindReplace(filelist: TStrings; find, replace: string);
var lw:IInLayoutWindow;
  i: Integer;
  fi: Integer;
begin
  for i := 0 to filelist.Count - 1 do
  begin
    lw:=app.OpenWindow('LayoutWindow',filelist[i])as IInLayoutWindow;
    for fi := 0 to lw.Figures.Count - 1 do
    begin
      if lw.Figures[fi].FigureType=inftText then
      begin
        ReplaceInText(lw.Figures[fi],find,replace);
      end;
      if lw.Figures[fi].FigureType=inftGrid then
      begin
        ReplaceInGrid(lw.Figures[fi],find,replace);
      end;
    end;
    lw.SaveLayout;
    lw.Close;
  end;
end;

procedure TLayoutMassOps.Print(filelist: TStrings);
var lw:IInLayoutWindow;
  i: Integer;
  fi: Integer;
  ff:string;
begin
  for i := 0 to filelist.Count - 1 do
  begin
    lw:=app.OpenWindow('LayoutWindow',filelist[i])as IInLayoutWindow;
    ff:=ExtractFileName(filelist[i]);
    lw.PrintPage(0,0,1,'печать авто '+ff,'');
    lw.Close;
  end;
end;

procedure TLayoutMassOps.ReplaceInGrid(fig: IInPictureFigure; find, replace: string);
var grid:IInPictureGridFigure;
  i: Integer;
  ri,ci: Integer;
  txt: string;
begin
  grid:=fig as IInPictureGridFigure;
  for ci:= 0 to grid.ColCount - 1 do
    for ri := 0 to grid.RowCount - 1 do
    begin
      txt:=grid.Text[ci,ri];
      if txt<>'' then
      begin
        txt:=StringReplace(txt,find,replace,[rfReplaceAll]);
        grid.Text[ci,ri]:=txt;
      end;
    end;


end;

procedure TLayoutMassOps.ReplaceInText(fig: IInPictureFigure; find, replace: string);
var txtf:IInPictureTextFigure;
begin
  txtf:=fig as IInPictureTextFigure;
  txtf.Text:=StringReplace(txtf.Text,find,replace,[rfReplaceAll]);
end;

end.
