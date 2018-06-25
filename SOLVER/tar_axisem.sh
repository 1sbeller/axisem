#!/bin/bash

fic='MXX_P_MYY'
tar -cvf ${fic}.tar ${fic}
rm -rf ${fic}

fic='MXY_MXX_M_MYY'
tar -cvf ${fic}.tar ${fic}
rm -rf ${fic}

fic='MXZ_MYZ'
tar -cvf ${fic}.tar ${fic}
rm -rf ${fic}

