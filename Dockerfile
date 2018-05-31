FROM riot/riotbuild

RUN git clone git://github.com/Microsoft/checkedc-llvm.git /tmp/checkedc && \
	git -C /tmp/checkedc reset --hard d8d78c7a13472b344e429d1ae320bc4f01ecb6db && \
	git clone git://github.com/Microsoft/checkedc-clang.git /tmp/checkedc/tools/clang && \
	git -C /tmp/checkedc/tools/clang reset --hard 76dc14d34b9210260c1044168d7debb627445c59 && \
	git clone git://github.com/Microsoft/checkedc.git /tmp/checkedc/projects/checkedc-wrapper/checkedc && \
	git -C /tmp/checkedc/projects/checkedc-wrapper/checkedc reset --hard 1768c2ae2aef912e514a788605497ea294f9622c && \
	mkdir /tmp/checkedc.obj && cd /tmp/checkedc.obj && cmake \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DCMAKE_C_FLAGS_MINSIZEREL_INIT="-Os" \
		-DCMAKE_CXX_FLAGS_MINSIZEREL_INIT="-Os" \
		-DCMAKE_EXE_LINKER_FLAGS_MINSIZEREL_INIT="-s" \
		-DLLVM_TARGETS_TO_BUILD="X86;ARM" \
		-DCMAKE_INSTALL_PREFIX=/ \
		-DLLVM_BUILD_TESTS=OFF \
		-DLLVM_BUILD_EXAMPLES=OFF \
		-DLLVM_BUILD_DOCS=OFF \
		-DLLVM_ENABLE_SPHINX=OFF \
		/tmp/checkedc && \
	make -j $(($(nproc) / 2)) && make DESTDIR=/opt/checkedc-llvm install && \
	rm -rfv /tmp/checkedc /tmp/checkedc.obj \
		/opt/checkedc-llvm/include /opt/checkedc-llvm/lib

