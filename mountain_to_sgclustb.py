import numpy as np 
from mountainlab_pytools import mdaio
import sys

if len(sys.argv)<2:
    print('Not enough input. I need the tetrode number #t (folder tet+#t where to find the files firings.mda and raw_filt.mda')
    exit()

tet= sys.argv[1]
fold='tet'+tet

a = mdaio.readmda(fold+'/raw_filt.mda')
b = mdaio.readmda(fold+'/firings.mda')

nC, L = a.shape # number of channels, length of recording

res = b[1,:].astype(int)
clu = b[2,:].astype(int)


# # MICHELE'S ORIGINAL CODE: FOR TETRODES WITH 4 WORKING CHANNELS
#  ----------------------------------------------------------------------
# c = np.zeros([len(res),4,32])
# for ir, r in enumerate(res):
#     print(ir, r)
#     if r > 16 and r < L-16:
#         c[ir,:,:] = a[:,r-15:r+17]

# # do PCA on the 4 channel separately
# d = np.zeros([len(res),13])
# d[:,-1] = res
# for i in range(4):
#     C = c[:,i,:].T@c[:,i,:]
#     lams, us = np.linalg.eig(C)
#     T = c[:,i,:]@us
#     d[:,i*3:i*3+3] = T[:,:3]
#     print(i*3,i*3+3)

#  ---------------------------------------------------------------------------

# THIS SHOULD WORK FOR TETRODES WITH 1,2,3 OR 4 WORKING CHANNELS
c = np.zeros([len(res),nC,32])
for ir, r in enumerate(res):
    if r > 16 and r < L-16:
        c[ir,:,:] = a[:,r-15:r+17]

# do PCA on the nC channels separately
d = np.zeros([len(res),13])
d[:,-1] = res
for i in range(nC):
    C = c[:,i,:].T@c[:,i,:]
    lams, us = np.linalg.eig(C)
    T = c[:,i,:]@us
    d[:,i*3:i*3+3] = T[:,:3]
    print(i*3,i*3+3)

# save d as plain text, toghether with clu and res
np.savetxt(fold+'/'+fold+'.res.'+tet,res,fmt='%i')
np.savetxt(fold+'/'+fold+'.clu.'+tet,[max(clu)+1]+list(clu+1),fmt='%i')
np.savetxt(fold+'/'+fold+'.fet.'+tet,d,fmt='%i',header = '13',comments='')
np.savetxt(fold+'/'+fold+'.mm.'+tet,[0,0,0,0,0,0,0,0])

# now save the file spk to have the spike shape in sgclust

c=np.swapaxes(c,1,2)

c = c / np.max(np.abs(c)) * 1024
c = c.astype(int)

with open(fold+'/'+fold+'.spk.'+tet, "wb") as binary_file:
    # Write text or bytes to the file
    for byte in c.flatten():
        binary_file.write(int(byte).to_bytes(2, byteorder='big',signed=True))

