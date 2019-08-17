use v6;
#  -- DO NOT EDIT --
# generated by: etc/generator.p6 

unit module LibXML::Native::Gen::xmlunicode;
# Unicode character APIs:
#    API for the Unicode character APIs  This file is automatically generated from the UCS description files of the Unicode Character Database
use LibXML::Native::Defs :LIB, :xmlCharP;

sub xmlUCSIsAegeanNumbers(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsAlphabeticPresentationForms(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsArabic(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsArabicPresentationFormsA(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsArabicPresentationFormsB(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsArmenian(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsArrows(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsBasicLatin(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsBengali(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsBlock(int32 $code, Str $block --> int32) is native(LIB) {*};
sub xmlUCSIsBlockElements(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsBopomofo(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsBopomofoExtended(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsBoxDrawing(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsBraillePatterns(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsBuhid(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsByzantineMusicalSymbols(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCJKCompatibility(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCJKCompatibilityForms(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCJKCompatibilityIdeographs(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCJKCompatibilityIdeographsSupplement(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCJKRadicalsSupplement(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCJKSymbolsandPunctuation(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCJKUnifiedIdeographs(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCJKUnifiedIdeographsExtensionA(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCJKUnifiedIdeographsExtensionB(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCat(int32 $code, Str $cat --> int32) is native(LIB) {*};
sub xmlUCSIsCatC(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatCc(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatCf(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatCo(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatCs(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatL(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatLl(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatLm(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatLo(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatLt(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatLu(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatM(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatMc(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatMe(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatMn(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatN(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatNd(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatNl(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatNo(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatP(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatPc(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatPd(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatPe(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatPf(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatPi(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatPo(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatPs(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatS(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatSc(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatSk(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatSm(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatSo(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatZ(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatZl(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatZp(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCatZs(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCherokee(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCombiningDiacriticalMarks(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCombiningDiacriticalMarksforSymbols(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCombiningHalfMarks(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCombiningMarksforSymbols(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsControlPictures(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCurrencySymbols(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCypriotSyllabary(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCyrillic(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsCyrillicSupplement(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsDeseret(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsDevanagari(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsDingbats(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsEnclosedAlphanumerics(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsEnclosedCJKLettersandMonths(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsEthiopic(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsGeneralPunctuation(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsGeometricShapes(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsGeorgian(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsGothic(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsGreek(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsGreekExtended(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsGreekandCoptic(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsGujarati(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsGurmukhi(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsHalfwidthandFullwidthForms(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsHangulCompatibilityJamo(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsHangulJamo(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsHangulSyllables(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsHanunoo(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsHebrew(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsHighPrivateUseSurrogates(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsHighSurrogates(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsHiragana(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsIPAExtensions(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsIdeographicDescriptionCharacters(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsKanbun(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsKangxiRadicals(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsKannada(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsKatakana(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsKatakanaPhoneticExtensions(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsKhmer(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsKhmerSymbols(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsLao(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsLatin1Supplement(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsLatinExtendedA(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsLatinExtendedAdditional(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsLatinExtendedB(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsLetterlikeSymbols(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsLimbu(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsLinearBIdeograms(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsLinearBSyllabary(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsLowSurrogates(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsMalayalam(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsMathematicalAlphanumericSymbols(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsMathematicalOperators(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsMiscellaneousMathematicalSymbolsA(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsMiscellaneousMathematicalSymbolsB(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsMiscellaneousSymbols(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsMiscellaneousSymbolsandArrows(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsMiscellaneousTechnical(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsMongolian(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsMusicalSymbols(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsMyanmar(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsNumberForms(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsOgham(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsOldItalic(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsOpticalCharacterRecognition(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsOriya(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsOsmanya(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsPhoneticExtensions(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsPrivateUse(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsPrivateUseArea(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsRunic(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsShavian(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsSinhala(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsSmallFormVariants(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsSpacingModifierLetters(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsSpecials(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsSuperscriptsandSubscripts(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsSupplementalArrowsA(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsSupplementalArrowsB(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsSupplementalMathematicalOperators(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsSupplementaryPrivateUseAreaA(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsSupplementaryPrivateUseAreaB(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsSyriac(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsTagalog(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsTagbanwa(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsTags(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsTaiLe(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsTaiXuanJingSymbols(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsTamil(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsTelugu(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsThaana(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsThai(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsTibetan(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsUgaritic(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsUnifiedCanadianAboriginalSyllabics(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsVariationSelectors(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsVariationSelectorsSupplement(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsYiRadicals(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsYiSyllables(int32 $code --> int32) is native(LIB) {*};
sub xmlUCSIsYijingHexagramSymbols(int32 $code --> int32) is native(LIB) {*};