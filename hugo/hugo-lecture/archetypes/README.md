# Archetypes

Use either "page bundles" or "single markdown files" for individual lectures. Lectures are "leafs"
in the branch hierarchy.

Folders which do not represent leafs must contain a "landing page", i.e. a file "`_index.md`".

**Do not use underscore ("`_`") nor blanks ("` `") in file names nor in folder names.**

Folders which contain an empty text file "`.noslides`" will be ignored when generating slides.


## Page Bundles

**Support for page bundles has been dropped. Please use single markdown files!**

```
content/
|___  _index.md             <= Landing Page
|___  mypage/               <= Page Bundle for Lecture "mypage"
  |___  index.md            <= Lecture
  |___  images/
    |___  wuppie.png        <= use "![](images/wuppie.png)"
  |___  files/
    |___  annotated.pdf     <= will be included automatically (lecture-bc, lecture-cy)
```

To reference images in `index.md` use `![](images/wuppie.png)`. This works in GH preview, and in
slides and generated pages.


## Single Markdown Files

```
content/
|___  _index.md             <= Landing Page
|___  mypage.md             <= Lecture "mypage" (Single Markdown File)
|___  mypage.images/
  |___  wuppie.png          <= use "![](mypage.images/wuppie.png)"
|___  mypage.files/
  |___  annotated.pdf       <= will be included automatically (lecture-bc, lecture-cy)
|___  images/
  |___  wuppie.png          <= use "![](images/wuppie.png)"
|___  files/
  |___  annotated.pdf       <= will be included automatically (lecture-bc, lecture-cy)
```

To reference images in `mypage.md` use `![](mypage.images/wuppie.png)`. This works in GH preview,
and in slides.

For generated pages we need to transform this to `![](../mypage.images/wuppie.png)` via Lua filter
or use a (new) custom shortcode. (to be done in https://github.com/PM-Dungeon/PM-Lecture/issues/128)

You could also just use `images/` and/or `files/`. Those folders are reachable from all pages in
this chapter ...
