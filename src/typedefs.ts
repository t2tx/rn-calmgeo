import { z } from 'zod';

// for config
const desiredAccuracyEnum = z.enum([
  'BEST_FOR_NAVIGATION',
  'BEST',
  'TEN_METERS',
  'HUNDRED_METERS',
  'KILOMETER',
  'THREE_KILOMETERS',
]);

const requestMethodEnum = z.enum(['GET', 'POST', 'PUT', 'DELETE']);

const configSchema = z.object({
  desiredAccuracy: desiredAccuracyEnum,
  distanceFilter: z.number().int(),
  disableSpeedMultiplier: z.boolean(),
  speedMultiplier: z.number(),
  stationaryRadius: z.number(),

  url: z.string().optional(),
  token: z.string().optional(),

  httpTimeout: z.number().int(),
  method: requestMethodEnum,
  autoSync: z.boolean(),
  syncThreshold: z.number().int(),
  maxBatchSize: z.number().int(),
  maxDaysToPersist: z.number().int().min(0),

  fetchActivity: z.boolean(),
});
type Config = z.infer<typeof configSchema>;

// for location
const activityTypeEnum = z.enum([
  'still',
  'on_foot',
  'walking',
  'running',
  'in_vehicle',
  'on_bicycle',
  'unknown',
]);
type ActivityTypeKey = z.infer<typeof activityTypeEnum>;

const locationSchema = z.object({
  id: z.string(),
  timestamp: z.string().datetime({ precision: 3 }),
  isMoving: z.boolean(),
  event: z.string().optional(),
  coords: z.object({
    latitude: z.number(),
    longitude: z.number(),
    accuracy: z.number(),
    altitude: z.number(),
    altitudeAccuracy: z.number(),
    ellipsoidalAltitude: z.number(),
    speed: z.number(),
    speedAccuracy: z.number(),
    heading: z.number(),
    headingAccuracy: z.number(),
    floor: z.number().optional(),
    mock: z.boolean().optional(),
    external: z.boolean().optional(),
  }),
  activity: z
    .object({
      type: activityTypeEnum,
      confidence: z.number(),
    })
    .optional(),
});
type Location = z.infer<typeof locationSchema>;

// for listener
const listenerSchema = z.function().args(locationSchema).returns(z.void());
type Listener = z.infer<typeof listenerSchema>;

export {
  desiredAccuracyEnum,
  requestMethodEnum,
  configSchema,
  type Config,
  activityTypeEnum,
  type ActivityTypeKey,
  locationSchema,
  type Location,
  listenerSchema,
  type Listener,
};
