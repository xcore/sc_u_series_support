// Copyright (c) 2013, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <xs1.h>
#include <xs1_su.h>

#define DEBUG_UNIT ADC
#include "debug_print.h"

#include "xassert.h"

#include "adc.h"

static inline unsigned chanend_res_id(chanend c)
{
    unsigned int id;
    asm("mov %0, %1" : "=r"(id): "r"(c));
    return id;
}

static void adc_validate_config(const_adc_config_ref_t config)
{
    // Ensure that at least one of the inputs is active
    int active = 0;
    for (; active < XS1_MAX_NUM_ADC; active++)
    {
        if (config.input_enable[active])
            break;
    }

    if (active == XS1_MAX_NUM_ADC)
        fail("Error: no ADC enabled");

    // Check the bits_per_sample is a valid value
    if ((config.bits_per_sample != ADC_8_BPS)  &&
        (config.bits_per_sample != ADC_16_BPS) &&
        (config.bits_per_sample != ADC_32_BPS))
    {
        fail("Error: Invalid bits_per_sample");
    }

    // Check that samples_per_packet is valid. The library is not written to
    // support streaming mode and wants to ensure that buffers won't overflow
    // regardless of how the library is used.
    if ((config.samples_per_packet == 0) || (config.samples_per_packet > 5))
        fail("Error: Invalid samples_per_packet");
}

void adc_disable_all(tileref periph_tile)
{
    unsigned data[1];
    data[0] = 0;
    write_periph_32(periph_tile, 2, 0x20, 1, data);
}

void adc_enable(tileref periph_tile, chanend adc_chan, out port trigger_port, const_adc_config_ref_t config)
{
    adc_validate_config(config);

    // Ensure that the global configuration is disabled, otherwise the individual ADC
    // configuration registers are read-only
    adc_disable_all(periph_tile);

    // Drive trigger port low to ensure calibration pulses are all seen
    trigger_port <: 0;

    // Configure each of the individual ADCs
    for (int i = 0; i < XS1_MAX_NUM_ADC; i++)
    {
        unsigned data[1];
        if (config.input_enable[i])
            data[0] = 0x1 | (chanend_res_id(adc_chan) & ~0xff);
        else
            data[0] = 0x0;
        if (write_periph_32(periph_tile, 2, i*4, 1, data) != 1)
            fail("Error: failed to write to peripheral register");
    }

    // Write the shared configuration
    {
        unsigned data[1];
        data[0]  = XS1_SU_ADC_EN_SET(0, 1);
        data[0] |= XS1_SU_ADC_BITS_PER_SAMP_SET(0, config.bits_per_sample);
        data[0] |= XS1_SU_ADC_SAMP_PER_PKT_SET(0, config.samples_per_packet);
        data[0] |= XS1_SU_ADC_GAIN_CAL_MODE_SET(0, config.calibration_mode);
        if (write_periph_32(periph_tile, 2, 0x20, 1, data) != 1)
            fail("Error: failed to write to peripheral register");
    }

    // Perform the ADC calibration - requires a number of initial pulses
    for (int i = 0; i < ADC_CALIBRATION_TRIGGERS; i++)
        adc_trigger(trigger_port);
}

// Drives a pulse which triggers the ADC to sample a value. The pulse width
// must be a minimum of 400ns wide for the ADC to detect it.
void adc_trigger(out port trigger_port)
{
    unsigned time;
    trigger_port <: 1 @ time;
    time += 40;                 // Ensure 1 is held for >400ns
    trigger_port @ time <: 0;
    time += 40;                 // Ensure 0 is held for >400ns
    trigger_port @ time <: 0;
}

void adc_trigger_packet(out port trigger_port, const_adc_config_ref_t config)
{
    for (int i = 0; i < config.samples_per_packet; i++)
        adc_trigger(trigger_port);
}

void adc_read(chanend adc_chan,
              const_adc_config_ref_t config,
              unsigned int &data)
{
    if (testct(adc_chan))
        chkct(adc_chan, XS1_CT_END);

    switch (config.bits_per_sample)
    {
        case ADC_8_BPS:
            data = inuchar(adc_chan);
            break;
        case ADC_16_BPS:
            data  = inuchar(adc_chan) << 8;
            data |= inuchar(adc_chan);
            break;
        case ADC_32_BPS:
            data = inuint(adc_chan);
            break;
    }
}

void adc_read_packet(chanend adc_chan,
              const_adc_config_ref_t config,
              unsigned int data[])
{
    switch (config.bits_per_sample)
    {
        case ADC_8_BPS:
            for (int i = 0; i < config.samples_per_packet; i++)
                data[i] = inuchar(adc_chan);
            break;
        case ADC_16_BPS:
            for (int i = 0; i < config.samples_per_packet; i++)
            {
                data[i]  = inuchar(adc_chan) << 8;
                data[i] |= inuchar(adc_chan);
            }
            break;
        case ADC_32_BPS:
            for (int i = 0; i < config.samples_per_packet; i++)
                data[i] = inuint(adc_chan);
            break;
    }
    chkct(adc_chan, XS1_CT_END);
}

