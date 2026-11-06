#!/bin/bash


# remove vite hot file on container stop
cleanup() {

    rm public/hot || true

    # ensure assets are built on exit
    npm run build
}

#Trap SIGTERM
trap cleanup SIGTERM SIGKILL

# install dependencies
npm install

# remove vite hot file on start
rm public/hot || true

# vite mode, watch vs dev
echo "Vite is going to run in $VITE_MODE mode"

if [ $VITE_MODE == 'watch' ]; then
    npm run watch &
fi

if [ $VITE_MODE == 'dev' ]; then
    npm run dev &
fi


#Wait
wait $!
