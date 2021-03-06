'use strict';

require('polyffils');
require('svg');
require('copywritingDate');
require('fakeLink');

require('_stylesheets/front/application');
require('./modules/stickingBaner')();
require('./modules/textEditor');
require('./modules/ellipsisPopUp');
require('./modules/popUpQuestion');
require('./modules/popUpComplaint');
require('./modules/openTags');
require('./modules/socialButton')();
require('./modules/suggestSearch');
require('./modules/landing');
require('./modules/dataPublished');
require('./modules/statisticsMetrika');
require('./modules/bestAnswer');
require('./modules/transmitEventGa');
require('./modules/themesDropDown');

// Callbacks advertisement
require('./modules/adsCB');
