go get -u \
    github.com/mdempsky/gocode \
    github.com/golang/protobuf/protoc-gen-go \
    google.golang.org/grpc \
    github.com/marwan-at-work/mod/cmd/mod \
    github.com/kylie-a/kx \
    golang.org/x/tools/gopls \
    go.mozilla.org/sops/cmd/sops \
    github.com/junegunn/fzf
GO111MODULE=on go get golang.org/x/tools/gopls@latest
