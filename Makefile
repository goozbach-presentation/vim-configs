all: 
	for i in _*; do   source=${PWD}/$$i;   target=${HOME}/$${i/_/.};   if [ -d $${source} ] ;   then      if [ -h $${target} ] ;     then        : ;     else        ln -sf $${source} $${target};     fi ;   else        ln -sf $${source} $${target};   fi ; done;

clean:
	find ${HOME} -maxdepth 1 -type l -ls | grep '/dot_files/' | tr -s ' ' | sed -e 's/^ //' | cut -d ' ' -f 11 | xargs rm -f
