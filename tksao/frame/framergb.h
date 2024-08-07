// Copyright (C) 1999-2024
// Smithsonian Astrophysical Observatory, Cambridge, MA, USA
// For conditions of distribution and use, see copyright notice in "copyright"

#ifndef __framergb_h__
#define __framergb_h__

#include "framea.h"
#include "colorscalergb.h"

// Frame

class FrameRGB : public FrameA {
 protected:
  ColorScaleRGB* colorScale[3]; // current color scale

protected:
  int isFrameRGB() {return 1;}
  unsigned char* fillImage(int, int, Coord::InternalSystem);
  void updateColorScale();
  void updateColorCells(int cnt);
  int validColorScale() 
    {return colorScale[0] && colorScale[1] && colorScale[2];}

 public:
  FrameRGB(Tcl_Interp*, Tk_Canvas, Tk_Item*);
  virtual ~FrameRGB();

  void getColorbarCmd();
  void getTypeCmd();

  void getRGBChannelCmd();
  void getRGBSystemCmd() {getSystem();}
  void getRGBViewCmd() {getView();}

  void loadPhotoCmd(const char*, const char*);
  void loadSlicePhotoCmd(const char*, const char*) {}
  void savePhotoCmd(const char*);

  void setRGBChannelCmd(const char*);
  void setRGBSystemCmd(Coord::CoordSystem sys) {setSystem(sys);}
  void setRGBViewCmd(int r, int g, int b) {setView(r,g,b);}
};

#endif
