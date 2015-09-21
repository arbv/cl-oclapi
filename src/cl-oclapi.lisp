(in-package :cl-user)
(defpackage cl-oclapi
  (:use :cl :cffi)
  (:export :cl-uchar
           :cl-uint
           :size-t
           :cl-platform-id
           :cl-get-platform-ids
           :cl-get-platform-info
           :cl-get-device-ids
           :cl-get-device-info
           :cl-create-sub-devices
           :cl-retain-device
           :cl-release-device))
(in-package :cl-oclapi)

(define-foreign-library libopencl
  (t (:default "libOpenCL")))

(use-foreign-library libopencl)

#| cl-platform.h |#
(defctype cl-char :int8)
(defctype cl-uchar :uint8)
(defctype cl-short :int16)
(defctype cl-ushort :uint16)
(defctype cl-int :int32)
(defctype cl-uint :uint32)
(defctype cl-long :int64)
(defctype cl-ulong :uint64)

(defctype cl-half :uint16)
(defctype cl-float :float)
(defctype cl-double :double)

(defctype size-t :uint64)
(defctype intptr-t :int64)
(defctype uintptr-t :uint64)

#| cl.h |#
(defctype cl-platform-id :pointer)
(defctype cl-device-id :pointer)
(defctype cl-context :pointer)
(defctype cl-command-queue :pointer)
(defctype cl-mem :pointer)
(defctype cl-program :pointer)
(defctype cl-kernel :pointer)
(defctype cl-event :pointer)
(defctype cl-sampler :pointer)

(defctype cl-bool cl-uint)
(defctype cl-bitfield cl-ulong)
(defctype cl-device-type cl-bitfield)
(defctype cl-platform-info cl-uint)
(defctype cl-device-info cl-uint)
(defctype cl-device-fp-config cl-bitfield)
(defctype cl-device-mem-cache-type cl-uint)
(defctype cl-device-local-mem-type cl-uint)
(defctype cl-device-exec-capabilities cl-bitfield)
(defctype cl-command-queue-properties cl-bitfield)
(defctype cl-device-partition-property intptr-t)
(defctype cl-device-affinity-domain cl-bitfield)

(defctype cl-context-properties intptr-t)
(defctype cl-context-info cl-uint)
(defctype cl-command-queue-info cl-uint)
(defctype cl-channel-order cl-uint)
(defctype cl-channel-type cl-uint)
(defctype cl-mem-flags cl-bitfield)
(defctype cl-mem-object-type cl-uint)
(defctype cl-mem-info cl-uint)
(defctype cl-mem-migration-flags cl-bitfield)
(defctype cl-image-info cl-uint)
(defctype cl-buffer-create-type cl-uint)
(defctype cl-addressing-mode cl-uint)
(defctype cl-filter-mode cl-uint)
(defctype cl-sampler-info cl-uint)
(defctype cl-map-flags cl-bitfield)
(defctype cl-program-info cl-uint)
(defctype cl-program-build-info cl-uint)
(defctype cl-program-binary-type cl-uint)
(defctype cl-build-status cl-int)
(defctype cl-kernel-info cl-uint)
(defctype cl-kernel-arg-info cl-uint)
(defctype cl-kernel-arg-address-qualifier cl-uint)
(defctype cl-kernel-arg-access-qualifier cl-uint)
(defctype cl-kernel-arg-type-qualifier cl-bitfield)
(defctype cl-kernel-work-group-info cl-uint)
(defctype cl-event-info cl-uint)
(defctype cl-command-type cl-uint)
(defctype cl-profiling-info cl-uint)

(defcstruct cl-image-format
  (image-channel-order cl-channel-order)
  (image-channel-data-type cl-channel-type))

(defcstruct cl-image-desc
  (image-type cl-mem-object-type)
  (image-width size-t)
  (image-height size-t)
  (image-depth size-t)
  (image-array-size size-t)
  (image-row-pitch size-t)
  (image-slice-pitch size-t)
  (num-mip-levels cl-uint)
  (num-samples cl-uint)
  (buffer cl-mem))

(defcstruct cl-buffer-region
  (origin size-t)
  (size size-t))

#| cl.h - error codes. |#

(export (defconstant +cl-success+ 0))
(export (defconstant +cl-device-not-found+ -1))
(export (defconstant +cl-device-not-available+ -2))
(export (defconstant +cl-compiler-not-available+ -3))
(export (defconstant +cl-mem-object-allocation-failure+ -4))
(export (defconstant +cl-out-of-resources+ -5))
(export (defconstant +cl-out-of-host-memory+ -6))
(export (defconstant +cl-profiling-info-not-available+ -7))
(export (defconstant +cl-mem-copy-overlap+ -8))
(export (defconstant +cl-image-format-mismatch+ -9))
(export (defconstant +cl-image-format-not-supported+ -10))
(export (defconstant +cl-build-program-failure+ -11))
(export (defconstant +cl-map-failure+ -12))
(export (defconstant +cl-misaligned-sub-buffer-offset+ -13))
(export (defconstant +cl-exec-status-error-for-events-in-wait-list+ -14))
(export (defconstant +cl-compile-program-failure+ -15))
(export (defconstant +cl-linker-not-available+ -16))
(export (defconstant +cl-link-program-failure+ -17))
(export (defconstant +cl-device-partition-failed+ -18))
(export (defconstant +cl-kernel-arg-info-not-available+ -19))

(export (defconstant +cl-invalid-value+ -30))
(export (defconstant +cl-invalid-device-type+ -31))
(export (defconstant +cl-invalid-platform+ -32))
(export (defconstant +cl-invalid-device+ -33))
(export (defconstant +cl-invalid-context+ -34))
(export (defconstant +cl-invalid-queue-properties+ -35))
(export (defconstant +cl-invalid-command-queue+ -36))
(export (defconstant +cl-invalid-host-ptr+ -37))
(export (defconstant +cl-invalid-mem-object+ -38))
(export (defconstant +cl-invalid-image-format-descriptor+ -39))
(export (defconstant +cl-invalid-image-size+ -40))
(export (defconstant +cl-invalid-sampler+ -41))
(export (defconstant +cl-invalid-binary+ -42))
(export (defconstant +cl-invalid-build-options+ -43))
(export (defconstant +cl-invalid-program+ -44))
(export (defconstant +cl-invalid-program-executable+ -45))
(export (defconstant +cl-invalid-kernel-name+ -46))
(export (defconstant +cl-invalid-kernel-definition+ -47))
(export (defconstant +cl-invalid-kernel+ -48))
(export (defconstant +cl-invalid-arg-index+ -49))
(export (defconstant +cl-invalid-arg-value+ -50))
(export (defconstant +cl-invalid-arg-size+ -51))
(export (defconstant +cl-invalid-kernel-args+ -52))
(export (defconstant +cl-invalid-work-dimension+ -53))
(export (defconstant +cl-invalid-work-group-size+ -54))
(export (defconstant +cl-invalid-work-item-size+ -55))
(export (defconstant +cl-invalid-global-offset+ -56))
(export (defconstant +cl-invalid-event-wait-list+ -57))
(export (defconstant +cl-invalid-event+ -58))
(export (defconstant +cl-invalid-operation+ -59))
(export (defconstant +cl-invalid-gl-object+ -60))
(export (defconstant +cl-invalid-buffer-size+ -61))
(export (defconstant +cl-invalid-mip-level+ -62))
(export (defconstant +cl-invalid-global-work-size+ -63))
(export (defconstant +cl-invalid-property+ -64))
(export (defconstant +cl-invalid-image-descriptor+ -65))
(export (defconstant +cl-invalid-compiler-options+ -66))
(export (defconstant +cl-invalid-linker-options+ -67))
(export (defconstant +cl-invalid-device-partition-count+ -68))

#| cl.h - OpenCL version |#
(export (defconstant +cl-version-1-0+ t))
(export (defconstant +cl-version-1-1+ t))
(export (defconstant +cl-version-1-2+ t))

#| cl.h - cl_bool |#
(export (defconstant +cl-false+ nil))
(export (defconstant +cl-true+ t))
(export (defconstant +cl-blocking+ +cl-true+))
(export (defconstant +cl-non-blocking+ +cl-false+))

#| cl.h - cl_platform_info |#
(export (defconstant +cl-platform-profile+ #x0900))
(export (defconstant +cl-platform-version+ #x0901))
(export (defconstant +cl-platform-name+ #x0902))
(export (defconstant +cl-platform-vendor+ #x0903))
(export (defconstant +cl-platform-extensions+ #x0904))

#| cl.h - platform API. |#

;; CL_API_SUFFIX__VERSION_1_0;
(defcfun ("clGetPlatformIDs" cl-get-platform-ids) cl-int
  (num-entries cl-uint)
  (platforms (:pointer cl-platform-id))
  (num-platforms (:pointer cl-uint)))

;; CL_API_SUFFIX__VERSION_1_0;
(defcfun ("clGetPlatformInfo" cl-get-platform-info) cl-int
  (platform cl-platform-id)
  (param-name cl-platform-info)
  (param-value-size size-t)
  (param-value :pointer)
  (param-value-size-ret (:pointer size-t)))

#| cl.h - Device APIs |#

;; CL_API_SUFFIX__VERSION_1_0;
(defcfun ("clGetDeviceIDs" cl-get-device-ids) cl-int
  (platform cl-platform-id)
  (device-type cl-device-type)
  (num-entries cl-uint)
  (devices (:pointer cl-device-id))
  (num-devices (:pointer cl-uint)))

;; CL_API_SUFFIX__VERSION_1_0;
(defcfun ("clGetDeviceInfo" cl-get-device-info) cl-int
  (device cl-device-id)
  (param-name cl-device-info)
  (param-value-size size-t)
  (param-value (:pointer :void))
  (param-value-size-ret (:pointer size-t)))

;; CL_API_SUFFIX__VERSION_1_2;
(defcfun ("clCreateSubDevices" cl-create-sub-devices) cl-int
  (in-device cl-device-id)
  (properties (:pointer cl-device-partition-property))
  (num-devices cl-uint)
  (out-devices (:pointer cl-device-id))
  (num-devices-ret (:pointer cl-uint)))

;; CL_API_SUFFIX__VERSION_1_2;
(defcfun ("clRetainDevice" cl-retain-device) cl-int
  (device cl-device-id))

;; CL_API_SUFFIX__VERSION_1_2;
(defcfun ("clReleaseDevice" cl-release-device) cl-int
  (device cl-device-id))
