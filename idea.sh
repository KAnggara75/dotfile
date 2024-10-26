main() {
    echo '#!/bin/sh' > bin/idea
    echo '' >> bin/idea
    echo 'open -na "IntelliJ IDEA CE.app" --args "$@"' >> bin/idea

    chmod +x bin/idea
}

main
