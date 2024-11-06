#include "momentum.h"

#include <cmath>
#include <iostream>

Momentum::Momentum() : ev{0}, px{0.0}, py{0.0}, pz{0.0} {}
Momentum::Momentum(Int_t ev, Float_t px, Float_t py, Float_t pz)
    : ev{ev}, px{px}, py{py}, pz{pz}, mag{magnitude()} {}
Float_t Momentum::magnitude() const {
    return sqrt(px * px + py * py + pz * pz);
}
Momentum::~Momentum() {}