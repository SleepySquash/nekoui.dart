'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "manifest.json": "fb9f75e5e7736b2d9cf1c9e3773ce8bf",
"assets/assets/location/furniture/bed1.png": "28617fbf4ae2eef4bbd13702382addeb",
"assets/assets/location/furniture/bathtub1.png": "ef4701ff30aea9c0866993b7efa85c72",
"assets/assets/location/furniture/fridge1.png": "1a7958a80979a81a12bdf2a9d5501ea9",
"assets/assets/location/furniture/toilet1.png": "bd01f58a9723a89414bc807d2ddc2a31",
"assets/assets/location/floor/wooden.jpeg": "e875cd2e6c56f3f7eb7c43467f79b3fb",
"assets/assets/conf.toml": "6efa0108cf20f102892a49482517efb9",
"assets/assets/font/Roboto-Light.ttf": "881e150ab929e26d1f812c4342c15a7c",
"assets/assets/font/Roboto-ThinItalic.ttf": "7bcadd0675fe47d69c2d8aaef683416f",
"assets/assets/font/Roboto-BoldItalic.ttf": "fd6e9700781c4aaae877999d09db9e09",
"assets/assets/font/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/assets/font/Roboto-Medium.ttf": "68ea4734cf86bd544650aee05137d7bb",
"assets/assets/font/BalsamiqSans-Regular.ttf": "18524b8dcfb7a7fa8650e2d9b3f17330",
"assets/assets/font/Roboto-BlackItalic.ttf": "c3332e3b8feff748ecb0c6cb75d65eae",
"assets/assets/font/BalsamiqSans-Bold.ttf": "c75d3e69ca7abfce44252cf9e3efe854",
"assets/assets/font/Roboto-Black.ttf": "d6a6f8878adb0d8e69f9fa2e0b622924",
"assets/assets/font/Roboto-Thin.ttf": "66209ae01f484e46679622dd607fcbc5",
"assets/assets/font/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/assets/font/BalsamiqSans-BoldItalic.ttf": "28231ae49f474820048e577ea368dbe6",
"assets/assets/font/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/assets/font/Roboto-MediumItalic.ttf": "c16d19c2c0fd1278390a82fc245f4923",
"assets/assets/font/BalsamiqSans-Italic.ttf": "a30c44ec69e52f41706f19beb7a51df6",
"assets/assets/font/Neucha-Regular.ttf": "ba10e84e04783d0cf957000b0386d2a9",
"assets/assets/font/Roboto-LightItalic.ttf": "5788d5ce921d7a9b4fa0eaa9bf7fec8d",
"assets/assets/character/Demon.png": "a0e0e3d89ec66e1714963b7f32329488",
"assets/assets/character/person.png": "f13ef1914deee531b5a538c48dd8c57c",
"assets/assets/character/Maple.png": "99bd616781b06f5edf59e4c057e5bc1f",
"assets/assets/character/Chocola.png": "67f8cb6767f15795051d022ac53e36f3",
"assets/assets/character/Azuki.png": "bc97f3522b437f14585dc63f67621725",
"assets/assets/character/Altera.png": "5e85d44d6a092a7ca0fe9b7725528b76",
"assets/assets/character/Cthulhu.png": "0157896a44fc0fdda59977bca3c0951c",
"assets/assets/character/Coconut.png": "a19892824d223d408dcba03ee2d74682",
"assets/assets/character/Vanilla.png": "13393ae0d0f9697ad1df90ca148ecbcc",
"assets/assets/character/Flandre.png": "3b05ef9d8811939b3725200f50c91e2e",
"assets/assets/character/Cinnamon.png": "0c5ce12dd4907675116cbed0456e2de2",
"assets/assets/character/Shigure.png": "c15552b1676517064c295400b2e86105",
"assets/assets/background/fridge.jpg": "fed0a49d06bb5598f75b282a952f6b7c",
"assets/assets/background/park.jpg": "78bff6d4b33786032dc53c85f7cc484f",
"assets/assets/background/job.jpg": "35331020955e92f4f2b91bad1d2a0710",
"assets/assets/background/menu.jpg": "332614f01c93714d9425b5227065b216",
"assets/assets/background/shopkeeper.jpg": "b26981238980053f2ca853ddbd34b3f3",
"assets/assets/background/kitty.jpeg": "c3b562063767d4ff24f6bd78d02b1cc0",
"assets/assets/background/grocery.jpg": "96a309049c68fea725404a525ab4203e",
"assets/assets/background/map.png": "d895d384d4d220b279d7385ec10abb9f",
"assets/assets/background/flow.png": "0699da3fc72d68b1e3a0b59163e5a6d1",
"assets/assets/background/wardrobe.jpg": "5ac59aeaf146adac13d6b639bb259971",
"assets/assets/neko/person.png": "f13ef1914deee531b5a538c48dd8c57c",
"assets/assets/neko/chibi.riv": "66996390ec7d73433545926ebbd6b074",
"assets/assets/neko/chibi.png": "05e86db73f4364a61920d6cc9a6b55c2",
"assets/assets/item/Donut.png": "d0e83c4a2f94c1e0eab33b2a80b9953e",
"assets/assets/item/MaidGloves.png": "61c9a8f72b7a3b2474fe1244b0ee2d44",
"assets/assets/item/GroceryBag.png": "a1a22f8bd6f6abc9c1cc76d9a49faa6c",
"assets/assets/item/SailorBlouse.png": "170ccd48da89b4c47edb71bf0db10926",
"assets/assets/item/BlackStockings.png": "c61fe881289c5c8e1e789d86527b5692",
"assets/assets/item/Cake.png": "fda2034bbef014cc6f366024c10d5c81",
"assets/assets/item/Bra1.png": "6d4b91b174b4621beaad883410b3f763",
"assets/assets/item/WhiteStockings.png": "37e76316823ef4dc026b0b4fc46bd5ec",
"assets/assets/item/Lootbox.png": "d7c084e953632313760f35b5d7959154",
"assets/assets/item/MaidShoes.png": "21f9bca39971f2b43ca32814556c7e2e",
"assets/assets/item/water_bottle.png": "d26c7a9ab3e40adc9268d98f2ba33a12",
"assets/assets/item/Icecream.png": "6d92c6a2e4af89b85262758ddd3771b0",
"assets/assets/item/MaidUniform.png": "7e89cb7908a2741099141374b4d42571",
"assets/assets/item/Candy.png": "356d813e3bc8c265046cf6eec9e4f970",
"assets/assets/item/FractionOfPie.png": "899aeb540f9e5a5711ed0750173c8114",
"assets/assets/item/NekoCollar.png": "5295f895be1fcbb19cb02e21756c636c",
"assets/assets/item/MaidHeadwear.png": "343c9bbad031e45804fc75c375490b27",
"assets/assets/item/PleatedSailorSkirt.png": "389986ecae59a068c45036f138d6e97e",
"assets/assets/item/Cupcake.png": "17841df89ff0d81f17c1f51b9ac8c06e",
"assets/assets/item/Star.png": "4529493671919028ef2e48b37dff2b02",
"assets/assets/item/Panties1.png": "1e087c9ac6fe98f81b9031944ce7d259",
"assets/assets/item/Trousers.png": "e30ad465708a0dd8c6c7d4d093811101",
"assets/NOTICES": "61dfdee4fba6e72df50a0788ddf27be6",
"assets/AssetManifest.json": "b77fe352c9880895c3f020ffb408a2fe",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"version.json": "703956d89d4a06abbbbc8a335c5003e0",
"flutter.js": "eb2682e33f25cd8f1fc59011497c35f8",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba",
"canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"index.html": "269ceb9710558092180762da7cbc4cdd",
"/": "269ceb9710558092180762da7cbc4cdd",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"main.dart.js": "73c4e216f698cb8c6f79b06c15e2d32f"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
