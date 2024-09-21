import { NativeEventEmitter, NativeModules, Platform } from 'react-native';
import {
  locationSchema,
  type Config,
  type Listener,
  type Location,
} from './typedefs';

const LINKING_ERROR =
  `The package 'react-native-calm-geo' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const rnCalmGeo = NativeModules.RnCalmGeo
  ? NativeModules.RnCalmGeo
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const events = new NativeEventEmitter(rnCalmGeo);

async function start(config: Config): Promise<boolean> {
  return rnCalmGeo.start(JSON.stringify(config));
}

async function config(config: Config): Promise<boolean> {
  return rnCalmGeo.config(JSON.stringify(config));
}

async function stop(): Promise<void> {
  return rnCalmGeo.stop();
}

async function getCount(): Promise<number> {
  return rnCalmGeo.getCount();
}

async function getLocation(): Promise<Location> {
  return rnCalmGeo.getLocation();
}

async function clear(): Promise<void> {
  return rnCalmGeo.clear();
}

async function sync(): Promise<void> {
  return rnCalmGeo.sync();
}

async function isRunning(): Promise<boolean> {
  return rnCalmGeo.isRunning();
}

function registerListener(listener: Listener) {
  events.addListener('onLocation', (locationJson: string) => {
    const mid = locationSchema.safeParse(JSON.parse(locationJson));
    if (!mid.success) {
      return;
    }
    listener(mid.data);
  });

  return () => {
    events.removeAllListeners('onLocation');
  };
}

export const RnCalmGeo = {
  start,
  config,
  stop,
  getCount,
  getLocation,
  clear,
  sync,
  isRunning,
  registerListener,
};
