#ifndef ETMUSICFEATUREXML_H
#define ETMUSICFEATUREXML_H


#define MF_VERSION				(0x00010000)

//define the element
#define MF_ELEM_BASIC_INFO			"basic_info"

#define MF_ATTR_VERSION					"version"
#define MF_ATTR_ID						"id"
#define MF_ATTR_MUSIC_STARTPOS			"music_startpos"
#define MF_ATTR_MUSIC_LENGTH			"music_length"



#define MF_ELEM_FEATURE_LIST			"feature_list"
#define MF_ELEM_FEATURE_VOLUME		"feature_volume"
#define MF_ELEM_FEATURE_ORIGINAL_ONSET			"feature_original_onset"
#define MF_ELEM_FEATURE_HEAVY_BEAT		"feature_heavy_beat"
#define MF_ELEM_FEATURE_PICKED_ONSET		"feature_picked_onset"
#define MF_ELEM_FEATURE_TEMPO			"feature_tempo"
#define MF_ELEM_FEATURE_SING			"feature_sing"
#define MF_ELEM_VOLUME					"volume"
#define MF_ELEM_ONSET					"onset"
#define MF_ELEM_SING					"sing"
#define MF_ELEM_FEATURE_NON_HEAVY_BEAT		"feature_non_HB"
#define MF_ELEM_PICKED_ONSET			"picked_onset"

#define MF_ELEM_HEAVY_BEAT				"heavy_beat"  //heave beat
#define MF_ELEM_NON_HEAVY_BEAT		"non_HB"

#define MF_ELEM_COMBINED_MF_ONSET	"feature_all_mf_onset"
#define MF_ELEM_MF_ONSET  "mf_onset"
#define MF_ATTR_IS_HB  "isHB"
#define POSTIVE		"P"
#define NEGATIVE	"N"

//#define MF_ATTR_TYPE					"type"
#define MF_ATTR_COUNT					"count"
#define MF_ATTR_ORIGINAL_TIMESPAN				"ori_timespan"
#define MF_ATTR_IS_DB_MODE				"is_dB_mode"
#define MF_ATTR_ORIGINAL_MIN_VOLUME				"ori_min_volume"
#define MF_ATTR_ORIGINAL_MAX_VOLUME				"ori_max_volume"
#define MF_ATTR_VALUE_RELATIVE_TO_MAX	"value_relative_to_max"
#define MF_ATTR_VALUE					"value"

#ifdef SUPPORT_EXTRA_DATA_FOR_DESIGNER
#define MF_ATTR_TIMEPOS					"TP"
#else
#define MF_ATTR_TIMEPOS					"timepos"
#endif


#define MF_ATTR_STARTPOS				"startpos"
#define MF_ATTR_ENDPOS					"endpos"
#define MF_ATTR_WEIGHT					"weight" //for heavy beat
#define MF_ATTR_BPM						"bpm"
#define MF_ATTR_CE_TIMEPOS				"CETP" //for cooleditor time format
#define MF_ATTR_CE_TIMEPOS_START "CETPStart"
#define MF_ATTR_CE_TIMEPOS_END 		"CETPEnd"
#define MF_ATTR_ABS_VOLUME_THRESHOLD			"absVolThreshold"
#define MF_ATTR_DELTA_VOLUME_THRESHOLD		"deltaVolThreshold"
#define MF_ATTR_ABS_VOLUME		"absVol"
#define MF_ATTR_DELTA_VOLUME		"deltaVol"
#define MF_ATTR_HB_SPAN_COVERED		"spanCovered" //for the onset


#define MF_ATTR_HB_SMALL_ABS_VOLUME				"sAbsVol"
#define MF_ATTR_HB_SMALL_DELTA_VOLUME			"sDeltaVol"
#define MF_ATTR_HB_SMALL_COVERER_SPAN			"sCoveredSpan" //the onset covered span is to small




//MDWord judgeSpan;
//MDWord intervalNeed;

#define MF_ATTR_HEAVY_BEAT_JUDGESPAN				"judgespan"
#define MF_ATTR_HEAVY_BEAT_INTERVAL_NEED			"intervalneed"


//#define MF_ATTR_HEAVY_BEAT_DELTA	"delta"
#define MF_ATTR_IDX						"idx"




//for UI Designer
#define MF_ATTR_AE_FPS					"ae_fps"
#define MF_ATTR_AE_FRAME_IDX			"ae_frame_idx"

#endif



