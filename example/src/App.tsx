import { useState, useEffect } from 'react';
import { StyleSheet, View, Text, Button } from 'react-native';
import {
  desiredAccuracyEnum,
  requestMethodEnum,
  RnCalmGeo,
  type Location,
} from 'rn-calmgeo';

const configJson = {
  desiredAccuracy: desiredAccuracyEnum.enum.BEST_FOR_NAVIGATION,
  distanceFilter: 16,
  disableSpeedMultiplier: false,
  speedMultiplier: 3.1,
  stationaryRadius: 25.0,

  httpTimeout: 10000,
  method: requestMethodEnum.enum.POST,

  autoSync: true,
  syncThreshold: 12,
  maxBatchSize: 250,
  maxDaysToPersist: 7,

  fetchActivity: true,
};

export default function App() {
  const [count, setCount] = useState<number | undefined>();
  const [result, setResult] = useState<string | undefined>();
  const [loca, setLoca] = useState<Location | undefined>();
  const [isRunning, setIsRunning] = useState<boolean | undefined>();

  useEffect(() => {
    RnCalmGeo.start(configJson).then((value: boolean) => {
      console.log('start', value);
      setResult(value ? 'success' : 'failed');
    });

    const clean = RnCalmGeo.registerListener((location) => {
      setLoca(location);

      RnCalmGeo.getCount().then((value: number) => {
        console.log('getCount', value);
        setCount(value);
      });
    });

    return clean;
  }, []);

  const handleIsRunning = async () => {
    const value = await RnCalmGeo.isRunning();
    console.log('isRunning', value);
    setIsRunning(value);
  };

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      <Text>Count: {count}</Text>
      <Text>Location: {JSON.stringify(loca, null, 2)}</Text>
      <Button title="Stop" onPress={() => RnCalmGeo.stop()} />
      <Button title="Restart" onPress={() => RnCalmGeo.config(configJson)} />
      <Button title="Sync" onPress={() => RnCalmGeo.sync()} />
      <Button title="Clear" onPress={() => RnCalmGeo.clear()} />
      <Button title="Location" onPress={() => RnCalmGeo.getLocation()} />
      <Button title={`Is Running - ${isRunning}`} onPress={handleIsRunning} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
