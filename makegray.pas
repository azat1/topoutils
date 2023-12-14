unit makegray;

interface

procedure  MakeLayerGray;
implementation
uses addn, Ingeo_TLB, InScripting_TLB, grayform, Controls, Graphics, Dialogs;

//rect, line, poly, circle,
procedure MakeFigureColor(pic:IInPictureFigure;color:TColor);
var
   rect:IInPictureRectFigure;
   ell:IInPictureEllipseFigure;
   line:IInPictureLineFigure;
   poly:IInPicturePolygonFigure;
   text:IInPictureTextFigure;
   //rect:IInPictureRectFigure;

begin
  case  pic.FigureType of
    inftRect:
    begin
      rect:=pic as IInPictureRectFigure;
      rect.Pen.Color:=color;
      rect.Brush.BackColor:=color;
      rect.Brush.HatchColor:=color;
    end;
    inftEllipse:
    begin
      ell:=pic as IInPictureEllipseFigure;
      ell.Pen.Color:=color;
      ell.Brush.BackColor:=color;
      ell.Brush.HatchColor:=color;
    end;
    inftLine:
    begin
      //l:=pic as IInPictureEllipseFigure;
      (pic as IInPictureLineFigure).Pen.Color:=color;
    end;
    inftPolygon:
    begin
      poly:=pic as IInPicturePolygonFigure;
      poly.Pen.Color:=color;
      poly.Brush.BackColor:=color;
      poly.Brush.HatchColor:=color;
    end;
    inftText:
    begin
      text:=pic as IInPictureTextFigure;
      text.Font.Color:=color;
    end;
  end;
end;

procedure MakeLayerColor(lar:IIngeoLayer; color:TColor);
var stl:IIngeoStyle;
    pntr:IIngeoPainter;
    tpntr:IIngeoTextPainter;
    stdpntr:IIngeoStdPainter;
    figpntr:IIngeoSymbolPainter;
  i: Integer;
  fi, pi: Integer;
begin
  for i := 0 to lar.Styles.Count - 1 do
  begin
    stl:=lar.Styles[i];
    for pi := 0 to stl.Painters.Count - 1 do
    begin
      pntr:=stl.Painters[pi];
      case pntr.PainterType of
        inptStd:begin
          stdpntr:=pntr as IIngeoStdPainter;
          if stdpntr.Pen.Color<>$FFFFFF then
            stdpntr.Pen.Color:=color;
          if stdpntr.Brush.HatchColor<>$FFFFFF then
            stdpntr.Brush.HatchColor:=color;
          if stdpntr.Brush.BackColor<>$FFFFFF then
            stdpntr.Brush.BackColor:=color;

        end;
        inptText:begin
          tpntr:=pntr as IIngeoTextPainter;
          tpntr.Font.Color:=color;
        end;
        inptSymbol:begin
          figpntr:=pntr as IIngeoSymbolPainter;
          for fi := 0 to figpntr.Picture.Figures.Count - 1 do
          begin
            MakeFigureColor(figpntr.Picture.Figures[fi],color);
          end;

        end;
      end;

    end;
    stl.Update;
  end;
  lar.Update;
end;

procedure MakeColor(target:integer; color:TColor);
var layer:IIngeoLayer;
    map:IIngeoMap;
    vmap:IIngeoVectorMap;
  i: Integer;
begin
  if target=0 then
  begin
    layer:=gAddon2.ActiveProjectView.ActiveLayerView.Layer;
    MakeLayerColor(layer,color);
  end;
  if target=1 then
  begin
    map:=gAddon2.ActiveProjectView.ActiveMapView.Map;
    if map.MapType<>inmtVector then
       exit;
    vmap:=map as IIngeoVectorMap;
    for i := 0 to vmap.Layers.Count - 1 do
    begin

      MakeLayerColor(vmap.Layers[i],color);
    end;
  end;

end;



procedure MakeLayerGray;
var
    f:TfGrayMaker;
    color:TColor;
    target:integer;
begin
  f:=TfGrayMaker.Create(nil);
  if f.ShowModal=mrOk then
  begin
    color:=f.clbColor.Selected;
    target:=f.rgTarget.ItemIndex;
    if target=-1 then
    begin
      ShowMessage('Не выбран диапазон!');

    end else
    begin
      MakeColor(target,color);
    end;

  end;
  f.Free;
end;


end.
