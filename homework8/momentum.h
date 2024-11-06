#ifndef __MOMENTUM_H__
#define __MOMENTUM_H__

#include <TObject.h>

class Momentum : public TObject {
   public:
    Momentum();
    Momentum(Int_t ev, Float_t px, Float_t py, Float_t pz);
    Float_t magnitude() const;
    virtual ~Momentum();
    Int_t ev;
    Float_t px;
    Float_t py;
    Float_t pz;
    Float_t mag;
   private:
    ClassDef(Momentum, 1);  // momentum
};

#endif