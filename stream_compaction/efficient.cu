#include <cuda.h>
#include <cuda_runtime.h>
#include "common.h"
#include "efficient.h"

namespace StreamCompaction {
    namespace Efficient {
        using StreamCompaction::Common::PerformanceTimer;
        PerformanceTimer& timer()
        {
            static PerformanceTimer timer;
            return timer;
        }

        __global__ void kernUpsweep(int n, int offset, int* data) {
          unsigned idx = blockIdx.x * blockDim.x + threadIdx.x;

          if (idx >= n) {
            return;
          }
          
          if (idx % offset == 0) {
            data[idx + offset - 1] += data[idx + (offset / 2) - 1];
          }
        }

        __global__ void kernDownsweep(int n, int offset, int* data) {
          unsigned idx = blockIdx.x * blockDim.x + threadIdx.x;

          if (idx >= n) {
            return;
          }

          if (idx % offset == 0) {
            int temp = data[idx + (offset / 2) - 1];
            data[idx + (offset / 2) - 1] = data[idx + offset - 1];
            data[idx + offset - 1] += temp;
          }
        }

        /**
         * Performs prefix-sum (aka scan) on idata, storing the result into odata.
         */
        void scan(int n, int *odata, const int *idata) {
          // TODO
          int upRoundedN = 1 << ilog2ceil(n);

          // device array
          int *dev_data;

          cudaMalloc((void**)&dev_data, upRoundedN * sizeof(int));
          cudaMemset(dev_data, 0, upRoundedN * sizeof(int));
          cudaMemcpy(dev_data, idata, n * sizeof(int), cudaMemcpyHostToDevice);

          int blockSize = 128;
          int blocksPerGrid = (upRoundedN + blockSize - 1) / blockSize;

          timer().startGpuTimer();

          // upsweep
          for (int d = 0; d < ilog2ceil(n); d++) {
            int offset = 1 << (d + 1);
            kernUpsweep<<<blocksPerGrid, blockSize>>>(upRoundedN, offset, dev_data);
          }

          // downsweep
          cudaMemset(&dev_data[upRoundedN - 1], 0, sizeof(int));
          for (int d = ilog2ceil(n) - 1; d >= 0; d--) {
            int offset = 1 << (d + 1);
            kernDownsweep<<<blocksPerGrid, blockSize>>>(upRoundedN, offset, dev_data);
          }

          timer().endGpuTimer();

          cudaMemcpy(odata, dev_data, n * sizeof(int), cudaMemcpyDeviceToHost);

          // free device arrays
          cudaFree(dev_data);
        }

        /**
         * Performs stream compaction on idata, storing the result into odata.
         * All zeroes are discarded.
         *
         * @param n      The number of elements in idata.
         * @param odata  The array into which to store elements.
         * @param idata  The array of elements to compact.
         * @returns      The number of elements remaining after compaction.
         */
        int compact(int n, int *odata, const int *idata) {
            timer().startGpuTimer();
            // TODO

            timer().endGpuTimer();
            return -1;
        }
    }
}
