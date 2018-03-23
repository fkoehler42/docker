FROM php

RUN echo "<?php echo 'This is an awesome index page !!';" > /tmp/index.php

CMD ["php", "-S", "0.0.0.0:80", "-t", "/tmp"]
